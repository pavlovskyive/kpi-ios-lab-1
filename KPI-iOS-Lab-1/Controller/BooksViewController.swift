//
//  BooksViewController.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 07.02.2021.
//

import UIKit
import SnapKit

class BooksViewController: UIViewController {
    
    var storageProvider: StorageProvider = FileStorage()
    
    var library: Library? {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView = UITableView(frame: view.bounds)
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        setupTableView()
        getBooksData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupTableView() {
        
        tableView.dataSource = self
        
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
                self?.library = library
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension BooksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        library?.books.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID") as! BookCell
        
        guard let book = library?.books[indexPath.row] else {
            return cell
        }
        
        cell.titleLabel.text = book.title
        cell.subtitleLabel.text = book.subtitle
        cell.priceLabel.text = book.price
        
        storageProvider.getImage(for: book) { result in
            switch result {
            case .success(let image):
                cell.cellImageView.image = image
            case .failure(let error):
                print(error)
            }
        }
        
        return cell
    }
}
