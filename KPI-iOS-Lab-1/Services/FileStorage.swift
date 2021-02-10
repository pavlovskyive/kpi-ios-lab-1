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

    func getImage(for imageName: String, completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
        guard !imageName.isEmpty,
              let image = UIImage(named: imageName) else {
            completionHandler(.failure(FileStorageError.couldNotLoadImage))
            return
        }

        completionHandler(.success(image))
    }

    func getDetailedBook(with identifier: String, completionHandler: @escaping (Result<DetailedBook, Error>) -> Void) {
        do {
            guard let path = Bundle.main.path(forResource: identifier, ofType: "txt"),
                  let jsonData = try String(contentsOfFile: path).data(using: .utf8) else {
                completionHandler(.failure(FileStorageError.couldNotReadFile))
                return
            }

            let detailedBook = try JSONDecoder().decode(DetailedBook.self, from: jsonData)
            completionHandler(.success(detailedBook))

        } catch {
            completionHandler(.failure(error))
        }
    }
}

enum FileStorageError: String, Error {
    case couldNotReadFile
    case couldNotLoadImage
}
