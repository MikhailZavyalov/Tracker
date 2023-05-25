import UIKit
import SwiftUI

final class AddNewTrackerViewController: UIViewController {
    var onNewTrackerCreated: ((Tracker) -> Void)?
    
    private let addNewTrackerViewLabel: UILabel = {
        let addNewTrackerViewLabel = UILabel()
        addNewTrackerViewLabel.translatesAutoresizingMaskIntoConstraints = false
        addNewTrackerViewLabel.text = "Cоздание трекера"
        return addNewTrackerViewLabel
    }()
    
    private let habitButton: UIButton = {
        let habitButton = UIButton()
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.tintColor = .black
        habitButton.layer.masksToBounds = true
        habitButton.layer.cornerRadius = 10
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.backgroundColor = .black
        return habitButton
    }()
    
    private let irregularEventButton: UIButton = {
        let irregularEventButton = UIButton()
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        irregularEventButton.tintColor = .black
        irregularEventButton.layer.masksToBounds = true
        irregularEventButton.layer.cornerRadius = 10
        irregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        irregularEventButton.backgroundColor = .black
        return irregularEventButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constConfig()
        view.backgroundColor = .white
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        irregularEventButton.addTarget(self, action: #selector(irregularEventButtonTapped), for: .touchUpInside)
    }
    
    private func constConfig() {
        view.addSubview(addNewTrackerViewLabel)
        view.addSubview(habitButton)
        view.addSubview(irregularEventButton)
        
        NSLayoutConstraint.activate([
            addNewTrackerViewLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addNewTrackerViewLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            habitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            habitButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 50),
            irregularEventButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 10),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc
    private func habitButtonTapped() {
        let viewController = TrackerSettingsViewController()
        viewController.onNewTrackerCreated = { tracker in
            viewController.dismiss(animated: true)
            self.onNewTrackerCreated?(tracker)
        }
        present(viewController, animated: true)
    }
    
    @objc
    private func irregularEventButtonTapped() {
        let viewController = TrackerSettingsViewController()
        viewController.onNewTrackerCreated = { tracker in
            viewController.dismiss(animated: true)
            self.onNewTrackerCreated?(tracker)
        }
        present(viewController, animated: true)
    }
}

struct AddNewTrackerViewController_Previews: PreviewProvider {
  static var previews: some View {
    let vc = AddNewTrackerViewController()
      
    return UIViewRepresented(makeUIView: { _ in vc.view })
  }
}
