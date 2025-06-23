//
//  FavouritesPersistenceService.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 23/06/2025.
//
import Combine
import Foundation

protocol FavouritesPersistenceServiceProtocol {
    func readFromFavouriteAdItems() -> AnyPublisher<[LocalAdItem], Error>
    func writeToFavouriteAdItems(items: [LocalAdItem]) -> AnyPublisher<URL, Error>
    func updateFavouriteAdItems(favouriteAds: [LocalAdItem]) -> AnyPublisher<URL, Error>
}

final class FavouritesPersistenceService: FavouritesPersistenceServiceProtocol {
    static let shared = FavouritesPersistenceService()
    private let fileManager: FileManager = FileManager.default
    
    private let fileName = "VendAdItem.json"
    
    func readFromFavouriteAdItems() -> AnyPublisher<[LocalAdItem],Error> {
        ioPublisher { fileUrl in
            let data = try Data(contentsOf: fileUrl)
            return try JSONDecoder().decode([LocalAdItem].self, from: data)
        }
    }
    
    
    func writeToFavouriteAdItems(items: [LocalAdItem]) -> AnyPublisher<URL,Error> {
        ioPublisher { fileUrl in
            let data = try JSONEncoder().encode(items)
            try data.write(to: fileUrl, options: .atomic)
            return fileUrl
        }
    }
    
    func updateFavouriteAdItems(favouriteAds: [LocalAdItem]) -> AnyPublisher<URL,Error> {
        readFromFavouriteAdItems()
            .catch { error -> AnyPublisher<[LocalAdItem], Error> in
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
}

