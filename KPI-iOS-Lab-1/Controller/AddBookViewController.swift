//
//  AddBookViewController.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 10.02.2021.
//

import UIKit
import SnapKit

class AddBookViewController: UIViewController {

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

        self.navigationController?.interactivePopGestureRecognizer?.delaysTouchesBegan = false

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(UIInputViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

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
}

extension AddBookViewController {

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {

        let offset = scrollView.contentOffset

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
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
