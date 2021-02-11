//
//  TextFieldWithLabel.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 10.02.2021.
//

import UIKit
import SnapKit

final class TextFieldWithLabel: UIView {

    public var primaryColor = UIColor.blue {
        didSet {
            textField.tintColor = primaryColor
            secondaryColor = primaryColor.withAlphaComponent(0.5)
        }
    }

    var secondaryColor = UIColor.tertiaryLabel {
        didSet {
            textField.layer.borderColor = secondaryColor.cgColor
            label.textColor = secondaryColor
        }
    }

    weak var parent: UIView?

    lazy var label: UILabel = {
        let label = UILabel()

        label.textColor = secondaryColor
        label.backgroundColor = .systemBackground
        label.font = .preferredFont(forTextStyle: .body)

        return label
    }()

    lazy var textField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.tintColor = primaryColor
        textField.textColor = .label
        textField.font = .preferredFont(forTextStyle: .body)
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .default

        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.layer.borderColor = secondaryColor.cgColor
        textField.layer.borderWidth = 1

        return textField
    }()

    private var isLabelUp: Bool = false {
        didSet {
            moveLabel(isUp: isLabelUp)
        }
    }

    private var isTextFieldFocused: Bool = false {
        didSet {
            styleLabel(isFocused: isTextFieldFocused)
            styleTextField(isFocused: isTextFieldFocused)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setup() {
        [textField, label].forEach { addSubview($0) }

        textField.delegate = self

        textField.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(self).inset(16)
            make.trailing.equalTo(self).inset(16)
            make.top.equalTo(self).inset(16)
        }

        label.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(textField).offset(15)
            make.centerY.equalTo(textField)
        }

        styleLabel(isFocused: false)
    }

    private func styleLabel(isFocused: Bool) {
        UIView.transition(
            with: label,
            duration: 0.15,
            options: .curveEaseInOut,
            animations: {
                if isFocused {
                    self.label.textColor = self.primaryColor
                } else {
                    self.label.textColor = self.secondaryColor
                }
            },
            completion: nil
        )
    }

    private func styleTextField(isFocused: Bool) {
        let animation = CABasicAnimation(keyPath: "borderColor")

        let fromValue: CGColor
        let toValue: CGColor

        if isFocused {
            fromValue = secondaryColor.cgColor
            toValue = primaryColor.cgColor
        } else {
            fromValue = primaryColor.cgColor
            toValue = secondaryColor.cgColor
        }

        animation.fromValue = fromValue
        animation.toValue = toValue

        animation.duration = 0.2

        textField.layer.add(animation, forKey: "borderColor")
        textField.layer.borderColor = toValue
    }

    private func moveLabel(isUp: Bool) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                if isUp {
                    let offsetX = self.label.frame.width * 0.1
                    let translation = CGAffineTransform(translationX: -offsetX, y: -26)
                    let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    self.label.transform = translation.concatenating(scale)
                } else {
                    self.label.transform = .identity
                }
            },
            completion: nil
        )
    }
}

extension TextFieldWithLabel: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !isLabelUp {
            isLabelUp = true
        }

        isTextFieldFocused = true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        isTextFieldFocused = false

        guard let text = textField.text else {
            return false
        }

        if isLabelUp && text.isEmpty {
            isLabelUp = false
        }
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        guard textField.keyboardType == .decimalPad else {
            return true
        }

        guard let oldText = textField.text, let range = Range(range, in: oldText) else {
            return true
        }

        let newText = oldText.replacingCharacters(in: range, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }

        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if let nextField = parent?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return false
    }
}

class TextFieldWithPadding: UITextField {

    var padding = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)

    init(padding: UIEdgeInsets? = nil) {

        if let padding = padding {
            self.padding = padding
        }

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
