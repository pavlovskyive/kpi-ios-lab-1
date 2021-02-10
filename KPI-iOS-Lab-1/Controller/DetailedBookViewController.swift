//
//  DetailedBookViewController.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 08.02.2021.
//

import UIKit
import SnapKit

class DetailedBookViewContoller: UIViewController {

    var storageProvider: StorageProvider?

    var detailedBook: DetailedBook? {
        didSet {
            guard let detailedBook = detailedBook,
                  let storageProvider = storageProvider else {
                return
            }

            // Image loaded one more time for aa reason: in table view quality of image can be low, but in detailed
            //  view it should be higher quality, so image will be obtained from detailed book image name.
            storageProvider.getImage(for: detailedBook.image) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.imageView.image = image
                    guard let imageView = self?.imageView else { return }
                    self?.stackView.insertArrangedSubview(imageView, at: 0)
                case .failure:
                    break
                }
            }

            let titleLabel = labelWithTitle(title: "Title", text: detailedBook.title)
            titleLabel.font = .preferredFont(forTextStyle: .title1)

            let subtitleLabel = labelWithTitle(title: "Subtitle", text: detailedBook.subtitle)
            subtitleLabel.font = .preferredFont(forTextStyle: .title2)

            let descriptionLabel = labelWithTitle(title: "Description", text: detailedBook.desc)
            let authorsLabel = labelWithTitle(title: "Authors", text: detailedBook.authors)
            let publisherLabel = labelWithTitle(title: "Publisher", text: detailedBook.publisher)
            let pagesLabel = labelWithTitle(title: "Pages", text: detailedBook.pages)
            let yearLabel = labelWithTitle(title: "Year", text: detailedBook.year)
            let ratingLabel = labelWithTitle(title: "Rating", text: "\(detailedBook.rating)/5")

            [
                titleLabel,
                subtitleLabel,

                spacer,

                descriptionLabel,

                spacer,

                authorsLabel,
                publisherLabel,

                spacer,

                pagesLabel,
                yearLabel,
                ratingLabel

            ].forEach { label in
                stackView.addArrangedSubview(label)

                label.snp.makeConstraints { (make) -> Void in
                    make.width.equalToSuperview()
                }

            }
        }
    }

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true

        return scrollView
    }()

    lazy var contentView = UIView()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 10

        return stackView
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    var spacer: UIView {
        let view = UIView()
        view.snp.makeConstraints { (make) in
            make.height.equalTo(10)
        }

        return view
    }

    func labelWithTitle(title: String, text: String) -> UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0

        let string = NSMutableAttributedString(string: "\(title): ")
        string.addAttribute(
            .foregroundColor,
            value: UIColor.secondaryLabel,
            range: NSRange(location: 0, length: string.length))

        let textString = NSMutableAttributedString(string: text)

        string.append(textString)

        label.attributedText = string

        return label
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        title = detailedBook?.title

        setupViews()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            imageView.snp.remakeConstraints { (make) -> Void in
                make.height.equalTo(200)
            }
        } else {
            imageView.snp.remakeConstraints { (make) -> Void in
                make.height.equalTo(300)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        setupConstraints()
    }

    private func setupConstraints() {

        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(scrollView.snp.top).inset(10)
            make.bottom.equalTo(scrollView.snp.bottomMargin)
            make.leading.equalTo(scrollView.snp.leadingMargin).inset(10)
            make.trailing.equalTo(scrollView.snp.trailingMargin).inset(10)

            make.centerX.equalToSuperview()
        }

        if UIDevice.current.orientation.isLandscape {
            imageView.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(200)
            }
        } else {
            imageView.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(300)
            }
        }
    }
}
