//
//  FavouritesPersistenceService.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 23/06/2025.
//
import Combine
import Foundation

protocol FavouritesPersistenceServiceProtocol {
    func readFromFavouriteAdItems() -> AnyPublisher<[AdItem], Error>
    func writeToFavouriteAdItems(items: [AdItem]) -> AnyPublisher<URL, Error>
    func updateFavouriteAdItems(favouriteAds: [AdItem]) -> AnyPublisher<URL, Error>
}

/// Service layer handles reading and writing raw data to locally saved folders.
final class FavouritesPersistenceService: FavouritesPersistenceServiceProtocol {
    static let shared = FavouritesPersistenceService()
    private let fileManager: FileManager = FileManager.default
    
    private let fileName = "VendAdItem.json"
    private let imagesFolderName = "VendAdImages"
    
    func readFromFavouriteAdItems() -> AnyPublisher<[AdItem],Error> {
        ioPublisher { fileUrl in
            guard self.fileManager.fileExists(atPath: fileUrl.path) else {
                return []
            }
            let data = try Data(contentsOf: fileUrl)
            return try JSONDecoder().decode([AdItem].self, from: data)
        }
    }
    
    // saves the ads image and json to a file in folders to use them offline
    func writeToFavouriteAdItems(items: [AdItem]) -> AnyPublisher<URL,Error> {
        ioPublisher { fileUrl in
            let adImageFolder = try self.createImagesFolderURL()
            let itemAndImage: [AdItem] = try items.map { item in
                if item.localImageFileName == nil,
                   let remoteURL = item.fullImageURL,
                   let imageData  = try? Data(contentsOf: remoteURL)
                {
                    let filename = "ad-\(item.id).png"
                    let destinationURL  = adImageFolder.appendingPathComponent(filename)
                    try imageData.write(to: destinationURL, options: .atomic)
                    item.localImageFileName = filename
                }
                return item
            }
            let data = try JSONEncoder().encode(itemAndImage)
            try data.write(to: fileUrl, options: .atomic)
            return fileUrl
        }
    }
    
    func updateFavouriteAdItems(favouriteAds: [AdItem]) -> AnyPublisher<URL,Error> {
        readFromFavouriteAdItems()
            .catch { error -> AnyPublisher<[AdItem], Error> in
                if (error as? CocoaError)?.code == .fileNoSuchFile {
                    return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                return Fail(error: error).eraseToAnyPublisher()
            }
            .map { existing in
                var updated = existing
                
                let toRemove = favouriteAds
                    .filter { !$0.isFavourite }
                    .map(\.id)
                updated.removeAll { toRemove.contains($0.id) }
                
                let toAdd = favouriteAds.filter { newAd in
                    newAd.isFavourite &&
                    !updated.contains(where: { $0.id == newAd.id })
                }
                updated.append(contentsOf: toAdd)
                
                return updated
            }
            .flatMap { self.writeToFavouriteAdItems(items: $0)}
            .eraseToAnyPublisher()
    }
    
    // helper functions to avoid duplicate code
    private func ioPublisher<T>(_ url: @escaping (URL) throws -> T) -> AnyPublisher<T, Error> {
        Future { [weak self] promise in
            DispatchQueue.global(qos: .utility).async {
                do {
                    guard let self = self else {
                        throw RequestError.underlyingError
                    }
                    
                    let fileURL = try self.createFileURL()
                    let result = try url(fileURL)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func createFileURL() throws -> URL {
        let docs = try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        return docs.appendingPathComponent(self.fileName)
    }
    
    private func createImagesFolderURL() throws -> URL {
        let docs = try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let imagesFolder = docs.appendingPathComponent(imagesFolderName, isDirectory: true)
        try fileManager.createDirectory(
            at: imagesFolder,
            withIntermediateDirectories: true,
            attributes: nil
        )
        return imagesFolder
    }
}

