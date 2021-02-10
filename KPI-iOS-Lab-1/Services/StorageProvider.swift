//
//  StorageProvider.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 07.02.2021.
//

import UIKit

protocol StorageProvider {
    func getBooks(completionHandler: @escaping (Result<Library, Error>) -> Void)
    func getImage(for imageName: String, completionHandler: @escaping (Result<UIImage, Error>) -> Void)
    func getDetailedBook(with identifier: String, completionHandler: @escaping (Result<DetailedBook, Error>) -> Void)
}
