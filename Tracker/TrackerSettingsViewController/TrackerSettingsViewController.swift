import UIKit
import SwiftUI

final class TrackerSettingsViewController: UIViewController {
    let trackersMainViewController = TrackersMainViewController()
    var onNewTrackerCreated: ((Tracker) -> Void)?
    
    private var currentSettings: TrackerSettings = .empty {
        didSet {
            updateUI()
        }
    }
    
    private let colorsForHabit: [UIColor] = [
        .red, .green, .blue, .systemPink, .yellow, .purple,
        .orange, .gray
    ]
    
    private var habitTypeButtons: [TrackerSettingsCellModel] = [
        TrackerSettingsCellModel(title: "Категория", subTitle: nil),
        TrackerSettingsCellModel(title: "Расписание", subTitle: nil)
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
        field.backgroundColor = UIColor(named: "Background [day]")
        field.layer.cornerRadius = 10
        field.heightAnchor.constraint(equalToConstant: 60).isActive = true
        field.placeholder = "Введите название трекера"
        return field
    }()
    
    private let categoryAndScheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    private let emojisCollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        return collectionView
    }()
    
    private let colorsCollectionView = {
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
        button.setTitleColor(UIColor(named: "Red"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "Red")?.cgColor
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cоздать", for: .normal)
        button.backgroundColor = UIColor(named: "Black [day]")
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: - удалить, когда будет сделано emoji и colorPicker
        currentSettings.emoji = "🏆"
        currentSettings.color = .init(uiColor: .green)
        
        categoryAndScheduleTableView.dataSource = self
        categoryAndScheduleTableView.delegate = self
        categoryAndScheduleTableView.register(TrackerSettingsTableViewCell.self, forCellReuseIdentifier: TrackerSettingsTableViewCell.reuseID)
        emojisCollectionView.register(EmojiAndColorCollectionViewCell.self, forCellWithReuseIdentifier: "emojiCell")
        emojisCollectionView.dataSource = self
        emojisCollectionView.delegate = self
        colorsCollectionView.register(EmojiAndColorCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        view.backgroundColor = .white
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        textField.delegate = self
        
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.resignFirstResponder()
    }
    
    private func setupConstraints() {
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
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryAndScheduleTableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            categoryAndScheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryAndScheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryAndScheduleTableView.heightAnchor.constraint(equalToConstant: 120),
            emojisCollectionView.topAnchor.constraint(equalTo: categoryAndScheduleTableView.bottomAnchor, constant: 30),
            emojisCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            emojisCollectionView.heightAnchor.constraint(equalToConstant: 120),
            emojisCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        guard let tracker = currentSettings.makeTracker() else { return }
        onNewTrackerCreated?(tracker)
    }
    
    @objc private func textFieldValueChanged() {
        currentSettings.title = textField.text
        updateUI()
    }
    
    private func updateUI() {
        if currentSettings.makeTracker() != nil {
            createButton.backgroundColor = UIColor(named: "Black [day]")
            createButton.isUserInteractionEnabled = true
        } else {
            createButton.backgroundColor = UIColor(named: "Light Gray")
            createButton.isUserInteractionEnabled = false
        }
//        textLimitHint.isHidden = textField.text?.count != 38
    }
}

extension TrackerSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitTypeButtons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackerSettingsTableViewCell.reuseID, for: indexPath)
        guard let settingsCell = cell as? TrackerSettingsTableViewCell else { return cell }
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
                self.habitTypeButtons[0].subTitle = categoryTitle
                self.currentSettings.categoryTitle = categoryTitle
                tableView.reloadData()
                categoryViewController?.dismiss(animated: true)
            }
            present(categoryViewController, animated: true)
        case 1:
            let scheduleViewController = ScheduleViewController(enabledWeekDays: currentSettings.daysOfWeek)
            scheduleViewController.onUserDidSelectSchedule = { [weak scheduleViewController] enabledDays in
                self.currentSettings.daysOfWeek = enabledDays
                if enabledDays == Set(Tracker.WeekDay.allCases) {
                    self.habitTypeButtons[1].subTitle = "Каждый день"
                } else {
                    self.habitTypeButtons[1].subTitle = enabledDays
                        .map {
                            $0.shortName
                        }.joined(separator: ", ")
                }
                tableView.reloadData()
                scheduleViewController?.dismiss(animated: true)
            }
            present(scheduleViewController, animated: true)
        default:
            return
        }
    }
}

extension TrackerSettingsViewController: UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmojisCollection().emojisArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "emojiCell",
            for: indexPath) as? EmojiAndColorCollectionViewCell
        
        cell?.labelView.text = EmojisCollection().emojisArray[indexPath.row]
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

extension TrackerSettingsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 38
    }
}

struct TrackerSettingsViewController_Previews: PreviewProvider {
    static var previews: some View {
        let vc = TrackerSettingsViewController()
        
        return UIViewRepresented(makeUIView: { _ in vc.view })
    }
}
