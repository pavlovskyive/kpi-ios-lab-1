//
//  Books.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 07.02.2021.
//

import UIKit

struct Library: Codable {
    let books: [Book]
}

struct Book: Codable, Hashable {
    let title, subtitle, isbn13, price: String
    let image: String
}

struct DetailedBook: Codable {
    let title, subtitle, authors, publisher: String
    let isbn13, pages, year, rating: String
    let desc, price, image: String
}
