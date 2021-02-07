//
//  FileStorage.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 07.02.2021.
//

import UIKit

class FileStorage: StorageProvider {
    func getBooks(completionHandler: @escaping (Result<Library, Error>) -> Void) {
        do {
            guard let path = Bundle.main.path(forResource: "BooksList", ofType: "txt"),
                  let jsonData = try String(contentsOfFile: path).data(using: .utf8) else {
                completionHandler(.failure(FileStorageError.couldNotReadFile))
                return
            }
            
            let books = try JSONDecoder().decode(Library.self, from: jsonData)
            completionHandler(.success(books))
            
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    func getImage(for book: Book, completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
        
//        if let documentsUrl = FileManager.default.urls(for: .libraryDirectory, in: .allDomainsMask).first {
//            let fileURL = documentsUrl.appendingPathComponent(book.image)
//            do {
//                let imageData = try Data(contentsOf: fileURL)
//                completionHandler(.success(UIImage(data: imageData)))
//            } catch {
//                completionHandler(.failure(error))
//            }
//        }
        let imageName = book.image
        guard !imageName.isEmpty,
              let image = UIImage(named: imageName) else {
            completionHandler(.failure(FileStorageError.couldNotLoadImage))
            return
        }
        
        completionHandler(.success(image))
    }
}

enum FileStorageError: String, Error {
    case couldNotReadFile
    case couldNotLoadImage
}
