//
//  BooksViewController.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 07.02.2021.
//

import UIKit
import SnapKit

class BooksViewController: UIViewController {

    public var storageProvider: StorageProvider = FileStorage()

    private var books: [Book] = []
    private var filteredBooks = [Book]()

    lazy var tableView = UITableView(frame: view.bounds)

    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self

        searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchBar.placeholder = "Search Books"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .prominent

        return searchController
    }()

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground

        navigationItem.title = "Library"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBookHandler))

        searchController.isActive = true

        setupTableView()
        getBooksData()
    }

    private func setupTableView() {

        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80

        tableView.register(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "CellID")

        tableView.snp.makeConstraints { (make) -> Void in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }

    private func getBooksData() {
        storageProvider.getBooks { [weak self] result in
            switch result {
            case .success(let library):
                self?.books = library.books
                self?.tableView.reloadData()
            case .failure:
                break
            }
        }
    }

    private func filterContentForSearchText(searchText: String) {
        filteredBooks = books.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
    }

    @objc private func addBookHandler() {
        let addBookViewController = AddBookViewController()
        addBookViewController.delegate = self

        present(UINavigationController(rootViewController: addBookViewController), animated: true)
    }
}

extension BooksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(searchController.searchBar.text?.isEmpty ?? true) {
            return filteredBooks.count
        }
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID") as? BookCell else {
            fatalError("Could not cast cell")
        }

        let book: Book

        if !(searchController.searchBar.text?.isEmpty ?? true) {
            book = filteredBooks[indexPath.row]
        } else {
            book = books[indexPath.row]
        }

        cell.titleLabel.text = book.title
        cell.subtitleLabel.text = book.subtitle
        cell.priceLabel.text = book.price

        storageProvider.getImage(for: book.image) { result in
            switch result {
            case .success(let image):
                cell.cellImageView.image = image
            case .failure:
                let image = UIImage(systemName: "book.closed")?.withRenderingMode(.alwaysTemplate)
                cell.cellImageView.image = image
                cell.cellImageView.tintColor = .secondaryLabel
            }
        }

        return cell
    }
}

extension BooksViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.appearWithAnimation(delay: Double(indexPath.row) * 0.05)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let book: Book

        if !(searchController.searchBar.text?.isEmpty ?? true) {
            book = filteredBooks[indexPath.row]
        } else {
            book = books[indexPath.row]
        }

        storageProvider.getDetailedBook(with: book.isbn13) { [weak self] result in
            switch result {
            case .success(let detailedBook):
                let detailedBookViewController = DetailedBookViewContoller()
                detailedBookViewController.storageProvider = self?.storageProvider
                detailedBookViewController.detailedBook = detailedBook

                self?.navigationController?.pushViewController(detailedBookViewController, animated: true)
            case .failure(let error):
                print(error)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let book: Book

            if !(searchController.searchBar.text?.isEmpty ?? true) {
                book = filteredBooks[indexPath.row]
                filteredBooks.remove(at: indexPath.row)
                guard let index = books.firstIndex(of: book) else {
                    return
                }
                books.remove(at: index)
            } else {
                books.remove(at: indexPath.row)
            }

            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}

extension BooksViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text ?? "")
        tableView.reloadData()
    }
}

extension BooksViewController: AddBookDelegate {
    func handleAddBook(book: Book) {
        books.append(book)
        let indexPath = IndexPath(row: books.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
