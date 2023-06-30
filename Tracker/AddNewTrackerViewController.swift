import UIKit
import SwiftUI

final class AddNewTrackerViewController: UIViewController {
    var onNewTrackerCreated: ((Tracker) -> Void)?
    
    private let addNewTrackerViewLabel: UILabel = {
        let addNewTrackerViewLabel = UILabel()
        addNewTrackerViewLabel.translatesAutoresizingMaskIntoConstraints = false
        addNewTrackerViewLabel.text = "addNewTrackerViewLabel.text".localized
        addNewTrackerViewLabel.textColor = Colors.black
        return addNewTrackerViewLabel
    }()
    
    private let habitButton: UIButton = {
        let habitButton = UIButton()
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.layer.masksToBounds = true
        habitButton.layer.cornerRadius = 16
        habitButton.backgroundColor = Colors.black
        habitButton.setTitleColor(Colors.white, for: .normal)
        habitButton.titleLabel?.font = UIFont(name: "SF Pro", size: 16)
        habitButton.setTitle("Привычка", for: .normal)
        return habitButton
    }()
    
    private let irregularEventButton: UIButton = {
        let irregularEventButton = UIButton()
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        irregularEventButton.setTitleColor(Colors.white, for: .normal)
        irregularEventButton.backgroundColor = Colors.black
        irregularEventButton.layer.masksToBounds = true
        irregularEventButton.layer.cornerRadius = 16
        irregularEventButton.titleLabel?.font = UIFont(name: "SF Pro", size: 16)
        irregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        return irregularEventButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        irregularEventButton.addTarget(self, action: #selector(irregularEventButtonTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(addNewTrackerViewLabel)
        view.addSubview(habitButton)
        view.addSubview(irregularEventButton)
        
        NSLayoutConstraint.activate([
            addNewTrackerViewLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addNewTrackerViewLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            habitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            habitButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    private func habitButtonTapped() {
        let viewController = TrackerSettingsViewController()
        viewController.onNewTrackerCreated = { tracker in
            viewController.dismiss(animated: true)
            self.onNewTrackerCreated?(tracker)
        }
        viewController.isModalInPresentation = true
        present(viewController, animated: true)
    }
    
    @objc
    private func irregularEventButtonTapped() {
        let viewController = TrackerSettingsViewController()
        viewController.onNewTrackerCreated = { tracker in
            viewController.dismiss(animated: true)
            self.onNewTrackerCreated?(tracker)
        }
        viewController.isModalInPresentation = true
        present(viewController, animated: true)
    }
}

struct AddNewTrackerViewController_Previews: PreviewProvider {
  static var previews: some View {
    let vc = AddNewTrackerViewController()
      
    return UIViewRepresented(makeUIView: { _ in vc.view })
  }
}
