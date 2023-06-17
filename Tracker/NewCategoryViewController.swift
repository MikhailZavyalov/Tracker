import UIKit
import SwiftUI

final class NewCategoryViewController: UIViewController {
    var onUserDidAddNewCategory: ((String) -> Void)?
    
    private let newCategoryLabel: UILabel = {
       let label = UILabel()
        label.textColor = Colors.black
        label.text = "Новая категория"
        return label
    }()
    
    private let newCategoryTextField: UITextField = {
        let textField = UITextField.textFieldWithInsets(insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        textField.backgroundColor = Colors.background
        textField.layer.cornerRadius = 16
        textField.placeholder = "Введите название категории"
        return textField
    }()
    
    private let newCategoryDoneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.black
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(Colors.white, for: .normal)
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        newCategoryTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        newCategoryTextField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        newCategoryTextField.addTarget(self, action: #selector(editingDidEndOnExit), for: .editingDidEndOnExit)
        newCategoryDoneButton.addTarget(self, action: #selector(newCategoryDoneButtonTapped), for: .touchUpInside)
        updateNewCategoryDoneButtonState()
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(newCategoryLabel)
        newCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(newCategoryTextField)
        newCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(newCategoryDoneButton)
        newCategoryDoneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newCategoryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            newCategoryLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            newCategoryTextField.topAnchor.constraint(equalTo: newCategoryLabel.bottomAnchor, constant: 38),
            newCategoryTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            newCategoryTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            newCategoryDoneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            newCategoryDoneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            newCategoryDoneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
        ])
    }
    
    @objc private func editingChanged() {
        updateNewCategoryDoneButtonState()
    }
    
    @objc private func editingDidBegin() {
        newCategoryTextField.becomeFirstResponder()
    }

    @objc private func editingDidEndOnExit() {
        newCategoryTextField.resignFirstResponder()
    }
    
    @objc private func newCategoryDoneButtonTapped() {
        onUserDidAddNewCategory?(newCategoryTextField.text ?? "")
    }
    
    private func updateNewCategoryDoneButtonState() {
        if isTextValid() {
            newCategoryDoneButton.backgroundColor = Colors.black
            newCategoryDoneButton.isUserInteractionEnabled = true
        } else {
            newCategoryDoneButton.backgroundColor = Colors.gray
            newCategoryDoneButton.isUserInteractionEnabled = false
        }
    }
    
    private func isTextValid() -> Bool {
        newCategoryTextField.text != nil
        && newCategoryTextField.text?.isEmpty == false
        && (newCategoryTextField.text!.unicodeScalars.contains { scalar in
            CharacterSet.alphanumerics.contains(scalar)
        } || newCategoryTextField.text!.contains { char in
            char.isEmoji
        })
    }
}

struct NewCategoryViewController_Previews: PreviewProvider {
  static var previews: some View {
    let vc = NewCategoryViewController()
      
    return UIViewRepresented(makeUIView: { _ in vc.view })
  }
}
