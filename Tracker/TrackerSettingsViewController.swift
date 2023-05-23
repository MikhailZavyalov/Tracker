import UIKit
import SwiftUI

final class TrackerSettingsViewController: UIViewController {
    let emojisForHabit = [ "🍇", "🍈", "🍉", "🍊", "🍋", "🍌",
                           "🍍", "🥭", "🍎", "🍏", "🍐", "🍒",
                           "🍓", "🫐", "🥝", "🍅", "🫒", "🥥"
    ]
    
    private let habitTypeButtons: [SettingsCellModel] = [
        SettingsCellModel(title: "Категория", accessoryType: .arrow, switchValue: false),
        SettingsCellModel(title: "Расписание", accessoryType: .arrow, switchValue: false)
    ]
    
    private let label: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Новая привычка"
        return title
    }()
    
    private let textField: UITextField = {
        let field = UITextField.textFieldWithInsets(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .lightGray
        field.layer.cornerRadius = 20
        field.placeholder = "Введите название трекера"
        return field
    }()
    
    private let categoryAndScheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 20
        return tableView
    }()
    
    private let emojisCollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        return collectionView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cоздать", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryAndScheduleTableView.dataSource = self
        categoryAndScheduleTableView.delegate = self
        categoryAndScheduleTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseID)
        emojisCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "emojiCell")
        emojisCollectionView.dataSource = self
        emojisCollectionView.delegate = self
        view.backgroundColor = .white
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        view.addSubview(categoryAndScheduleTableView)
        categoryAndScheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emojisCollectionView)
        emojisCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonsStackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        view.addSubview(buttonsStackView)
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 10
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 80),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            categoryAndScheduleTableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            categoryAndScheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            categoryAndScheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            categoryAndScheduleTableView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -300),
            emojisCollectionView.topAnchor.constraint(equalTo: categoryAndScheduleTableView.bottomAnchor, constant: 0),
            emojisCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            emojisCollectionView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -20),
            emojisCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    @objc func cancelButtonTapped() {
        print("cancelButtonTapped")
    }
    
    @objc func createButtonTapped() {
        print("createButtonTapped")
    }
}

extension TrackerSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitTypeButtons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseID, for: indexPath)
        guard let settingsCell = cell as? SettingsTableViewCell else { return cell }
        settingsCell.configure(with: habitTypeButtons[indexPath.row])
        return settingsCell
    }
}

extension TrackerSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let categoryViewController = CategoryViewController()
            categoryViewController.onUserDidSelectCategory = { [weak categoryViewController] categoryTitle in
                // Добавить тайтл в ячейку с категорией
                print(categoryTitle)
                categoryViewController?.dismiss(animated: true)
            }
            present(categoryViewController, animated: true)
        case 1:
            let scheduleViewController = ScheduleViewController()
            present(scheduleViewController, animated: true)
        default:
            return
        }
    }
}

extension TrackerSettingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojisForHabit.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "emojiCell",
            for: indexPath) as? EmojiCollectionViewCell
        
        cell?.emogiLabelView.text = emojisForHabit[indexPath.row]
        return cell!
    }
}

extension TrackerSettingsViewController: UICollectionViewDelegate {
    
}

extension TrackerSettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 8, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}

struct TrackerSettingsViewController_Previews: PreviewProvider {
    static var previews: some View {
        let vc = TrackerSettingsViewController()
        
        return UIViewRepresented(makeUIView: { _ in vc.view })
    }
}
