//
//  AddBookViewController.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 10.02.2021.
//

import UIKit
import SnapKit

protocol AddBookDelegate: AnyObject {
    func handleAddBook(book: Book)
}

class AddBookViewController: UIViewController {

    weak var delegate: AddBookDelegate?

    typealias Field = (title: String, keyboardType: UIKeyboardType)

    private var gradientColors = UIColor.randomGradient()

    private var fields: [Field] = [
        (title: "Title", keyboardType: .default),
        (title: "Subtitle", keyboardType: .default),
        (title: "Price", keyboardType: .decimalPad)
    ]
    private var textFields = [TextFieldWithLabel]()

    lazy var scrollView = UIScrollView()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10

        return stackView
    }()

    lazy var submitButton: UIButton = {
        let button = GradientButton()
        button.colors = gradientColors
        button.setTitle("Submit Book", for: .normal)
        button.addTarget(self, action: #selector(addBook), for: .touchUpInside)

        return button
    }()

    lazy var gradientImage: GradientImage = {
        let image = GradientImage()

        image.colors = gradientColors

        image.imageMaskView.image = UIImage(systemName: "books.vertical")

        return image
    }()

    lazy var spacerView = UIView()

    func makeTextField(index: Int, placeholder: String) -> TextFieldWithLabel {
        let textField = TextFieldWithLabel()

        textField.primaryColor = gradientColors.1
        textField.textField.tag = index
        textField.parent = stackView

        textField.label.text = placeholder

        return textField
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil)

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(UIInputViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupViews() {

        navigationItem.title = "Add Book"

        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)

        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(gradientImage)

        fields.enumerated().forEach { (index, field) in
            let textField = makeTextField(index: index, placeholder: field.title)
            textField.textField.keyboardType = field.keyboardType

            textFields.append(textField)
            stackView.addArrangedSubview(textField)

            textField.snp.makeConstraints { (make) -> Void in
                make.width.equalToSuperview()
                make.height.equalTo(50)
            }
        }

        stackView.addArrangedSubview(spacerView)
        stackView.addArrangedSubview(submitButton)

        setupConstraints()
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }

        stackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(scrollView).inset(50)
            make.bottom.equalTo(scrollView).inset(10)
            make.leading.equalTo(scrollView.snp.leadingMargin).inset(10)
            make.trailing.equalTo(scrollView.snp.trailing).inset(10)
            make.centerX.equalTo(scrollView.snp.centerXWithinMargins)
        }

        gradientImage.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(200)
        }

        spacerView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(20)
        }

        submitButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(scrollView.snp.bottom).inset(10)
            make.width.lessThanOrEqualToSuperview()
        }
    }

    @objc private func addBook() {
        let title = textFields[0].textField.text ?? ""
        let subtitle = textFields[1].textField.text ?? ""
        let priceText = textFields[2].textField.text ?? ""

        guard !title.isEmpty,
              !subtitle.isEmpty,
              let price = Float(priceText),
              price > 0 else {
            let alertController = UIAlertController(
                title: "Bad input",
                message: "Please, check all the fields and correct mistakes.",
                preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "OK", style: .default)

            alertController.addAction(okAction)
            present(alertController, animated: true)

            return
        }

        let book = Book(title: title, subtitle: subtitle, isbn13: UUID().uuidString, price: "$\(price)", image: "")

        self.dismiss(animated: true) {
            self.delegate?.handleAddBook(book: book)
        }
    }
}

extension AddBookViewController {

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {

        let offset = scrollView.contentOffset

        guard let userInfo = notification.userInfo,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        else { return }

        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 40
        scrollView.contentInset = contentInset

        scrollView.setContentOffset(offset, animated: true)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
    }
}
