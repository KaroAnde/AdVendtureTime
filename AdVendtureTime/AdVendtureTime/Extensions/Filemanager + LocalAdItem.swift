//
//  Filemanager + LocalAdItem.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 23/06/2025.
//
import Foundation
import Combine

extension FileManager {
    
    func testWriteToLocalAdItem(newFavouriteAds: [LocalAdItem]) -> AnyPublisher<URL, Error> {
        readFavouriteAds().catch { error -> AnyPublisher<[LocalAdItem], Error> in
            if (error as? CocoaError)?.code == .fileNoSuchFile {
                return Just([])
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            return Fail(error: error)
                .eraseToAnyPublisher()
        }.map { existingAds in
            var updatedAds = existingAds
            
            let toAdd = newFavouriteAds.filter { newAd in
                !updatedAds.contains(where: { $0.id == newAd.id })
            }
            updatedAds.append(contentsOf: toAdd)
            return updatedAds
        }.flatMap { updatedAds in
            self.writeToLocalAdItem(adItem: updatedAds)
        }
        .eraseToAnyPublisher()
    }
    
    func writeToLocalAdItem(adItem: [LocalAdItem], subFolder: String? = nil) -> AnyPublisher<URL, Error> {
        Future { [weak self] promise in
            DispatchQueue.global(qos: .utility).async {
                do {
                    guard let fileManager = self else {
                        throw RequestError.underlyingError
                    }
                    
                    
                    // get document directory
                    guard let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        throw RequestError.unsupportedURL
                    }
                    
                    var targetFolder = documentsFolder
                    // check for subfolder
                    if let subFolder = subFolder {
                        targetFolder = documentsFolder.appendingPathComponent(subFolder, isDirectory: true)
                        try fileManager.createDirectory(
                            at: targetFolder,
                            withIntermediateDirectories: true,
                            attributes: nil
                        )
                    }
                    // build full url
                    let fileURL = targetFolder.appendingPathComponent("VendAdItem.json")
                    
                    
                    let data = try JSONEncoder().encode(adItem)
                    try data.write(to: fileURL, options: .atomic)
                    
                    promise(.success(fileURL))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func readFavouriteAds(subFolder: String? = nil) -> AnyPublisher<[LocalAdItem], Error> {
        Future { [weak self] promise in
            DispatchQueue.global(qos: .utility).async {
                do {
                    guard let fileManager = self else {
                        throw RequestError.underlyingError
                    }
                    
                    guard let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        throw RequestError.unsupportedURL
                    }
                    
                    var targetFolder = documentsFolder
                    // check for subfolder
                    if let subFolder = subFolder {
                        targetFolder = documentsFolder.appendingPathComponent(subFolder, isDirectory: true)
                        try fileManager.createDirectory(
                            at: targetFolder,
                            withIntermediateDirectories: true,
                            attributes: nil
                        )
                    }
                    
                    let fileURL = targetFolder.appendingPathComponent("VendAdItem.json")
                    
                    let data = try Data(contentsOf: fileURL)
                    let adItems = try JSONDecoder().decode([LocalAdItem].self, from: data)
                    
                    promise(.success(adItems))
                    
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func removeFavouriteAdItem(adToRemove: LocalAdItem) -> AnyPublisher<URL, Error> {
        readFavouriteAds().map { existingAds in
            existingAds.filter { $0.id != adToRemove.id }
        }.flatMap { filteredAds in
            self.writeToLocalAdItem(adItem: filteredAds)
        }.eraseToAnyPublisher()
    }
}

