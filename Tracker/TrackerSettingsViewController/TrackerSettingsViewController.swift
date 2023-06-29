import UIKit
import SwiftUI

final class TrackerSettingsViewController: UIViewController {
    private enum Const {
        static let pickersHorizontalInsets: CGFloat = 16
        static let bottomButtonsHeight: CGFloat = 60
        static let bottomButtonsTopInset: CGFloat = 8
        static let bottomButtonsBottomInset: CGFloat = 16
    }
    
    let trackersMainViewController = TrackersMainViewController()
    var onNewTrackerCreated: ((Tracker) -> Void)?

    private var editingTracker: Tracker?
    private var currentSettings: TrackerSettings {
        didSet {
            updateUI()
        }
    }
    
    private var habitTypeButtons: [TrackerSettingsCellModel] = [
        TrackerSettingsCellModel(title: "Категория", subTitle: nil),
        TrackerSettingsCellModel(title: "Расписание", subTitle: nil)
    ]
    
    private let scrollView = UIScrollView()

    private let titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = Colors.black
        title.font = .systemFont(ofSize: 16, weight: .medium)
        return title
    }()

    private let daysCountLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = Colors.black
        title.font = .systemFont(ofSize: 32, weight: .bold)
        return title
    }()
    
    private let textField: UITextField = {
        let field = UITextField.textFieldWithInsets(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = Colors.background
        field.textColor = Colors.black
        field.attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [.foregroundColor: Colors.gray]
        )
        field.layer.cornerRadius = 16
        field.clearButtonMode = .whileEditing
        return field
    }()
    
    private let categoryAndScheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private static let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let emojiPicker = EmojisPickerView(emojis: emojis)
    
    private static let colors = ColorSelection.allCases.map { UIColor(named: $0.rawValue)! }
    
    private let colorPicker = ColorsPickerView(colors: colors)
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить", for: .normal)
        button.backgroundColor = Colors.white
        button.setTitleColor(Colors.red, for: .normal)
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: Const.bottomButtonsHeight).isActive = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "Red")?.cgColor
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cоздать", for: .normal)
        button.setTitleColor(Colors.white, for: .normal)
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: Const.bottomButtonsHeight).isActive = true
        return button
    }()

    init(editingTracker: Tracker? = nil) {
        self.editingTracker = editingTracker
        if let editingTracker {
            currentSettings = TrackerSettings(
                color: editingTracker.color,
                title: editingTracker.title,
                emoji: editingTracker.emoji,
                categoryTitle: editingTracker.categoryTitle,
                daysOfWeek: editingTracker.daysOfWeek
            )

            textField.text = editingTracker.title
            habitTypeButtons[0].subTitle = editingTracker.categoryTitle
            habitTypeButtons[1].subTitle = subtitleFrom(enabledDays: editingTracker.daysOfWeek)
            emojiPicker.selectEmoji(editingTracker.emoji)
            colorPicker.selectColor(editingTracker.color.uiColor)
        } else {
            currentSettings = .empty
        }
        super.init(nibName: nil, bundle: nil)

        guard let editingTracker else { return }
        let daysCount = CoreDataStorage.shared.trackerRecords.filter { $0.trackerId == editingTracker.id }.count
        daysCountLabel.text = "\(daysCount) дней"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white

        titleLabel.text = editingTracker != nil ? "Редактирование привычки" : "Новая привычка"
        daysCountLabel.isHidden = editingTracker == nil

        categoryAndScheduleTableView.dataSource = self
        categoryAndScheduleTableView.delegate = self
        categoryAndScheduleTableView.register(TrackerSettingsTableViewCell.self, forCellReuseIdentifier: TrackerSettingsTableViewCell.reuseID)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        textField.delegate = self
        
        emojiPicker.didPickEmoji = { [weak self] emoji in
            self?.currentSettings.emoji = emoji
        }
        
        colorPicker.didPickColor = { [weak self] color in
            self?.currentSettings.color = Tracker.Color(uiColor: color)
        }
        setupConstraints()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.resignFirstResponder()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        var scrollInset = scrollView.contentInset
        scrollInset.top = view.safeAreaInsets.top + 27
        let bottomContentInset = Const.bottomButtonsBottomInset + Const.bottomButtonsTopInset + Const.bottomButtonsHeight
        scrollInset.bottom = bottomContentInset + view.safeAreaInsets.bottom
        scrollView.contentInset = scrollInset
    }
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(categoryAndScheduleTableView)
        categoryAndScheduleTableView.translatesAutoresizingMaskIntoConstraints = false

        let titleStack = UIStackView(arrangedSubviews: [titleLabel, daysCountLabel])
        titleStack.axis = .vertical
        titleStack.spacing = 38
        titleStack.alignment = .center
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(titleStack)
        
        scrollView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(emojiPicker)
        emojiPicker.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(colorPicker)
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonsStackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        
        view.addSubview(buttonsStackView)
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 8
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        let effect = UIBlurEffect(style: .regular)
        let buttonsContainer = UIVisualEffectView(effect: effect)
        buttonsContainer.contentView.addSubview(buttonsStackView)
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer.contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsContainer)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            titleStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            titleStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 30),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            categoryAndScheduleTableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            categoryAndScheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryAndScheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryAndScheduleTableView.heightAnchor.constraint(equalToConstant: 150),
            
            emojiPicker.topAnchor.constraint(equalTo: categoryAndScheduleTableView.bottomAnchor, constant: 30),
            emojiPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Const.pickersHorizontalInsets),
            emojiPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Const.pickersHorizontalInsets),
            emojiPicker.heightAnchor.constraint(equalToConstant: Self.calculateEmojiPickerHeight()),
            
            colorPicker.topAnchor.constraint(equalTo: emojiPicker.bottomAnchor, constant: 30),
            colorPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Const.pickersHorizontalInsets),
            colorPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Const.pickersHorizontalInsets),
            colorPicker.heightAnchor.constraint(equalToConstant: Self.calculateColorPickerHeight()),
            colorPicker.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            buttonsContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            buttonsContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonsContainer.heightAnchor.constraint(equalTo: buttonsContainer.contentView.heightAnchor),
            buttonsContainer.widthAnchor.constraint(equalTo: buttonsContainer.contentView.widthAnchor),
            buttonsContainer.topAnchor.constraint(equalTo: buttonsContainer.contentView.topAnchor),

            buttonsStackView.topAnchor.constraint(equalTo: buttonsContainer.contentView.topAnchor, constant: Const.bottomButtonsTopInset),
            buttonsStackView.trailingAnchor.constraint(equalTo: buttonsContainer.contentView.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Const.bottomButtonsBottomInset),
            buttonsStackView.leadingAnchor.constraint(equalTo: buttonsContainer.contentView.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor)
        ])
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        let tracker: Tracker
        if let editingTracker {
            tracker = editingTracker
            currentSettings.editTracker(tracker)
        } else {
            guard let newTracker = currentSettings.makeTracker() else { return }
            tracker = newTracker
        }
        onNewTrackerCreated?(tracker)
    }
    
    @objc private func textFieldValueChanged() {
        currentSettings.title = textField.text
        updateUI()
    }
    
    private func updateUI() {
        if currentSettings.makeTracker() != nil {
            createButton.backgroundColor = Colors.black
            createButton.isUserInteractionEnabled = true
        } else {
            createButton.backgroundColor = Colors.gray
            createButton.isUserInteractionEnabled = false
        }
//        textLimitHint.isHidden = textField.text?.count != 38
    }
    
    private static func calculateEmojiPickerHeight() -> CGFloat {
        let width = UIScreen.main.bounds.width - 2 * Const.pickersHorizontalInsets
        let lineItemCountEmoji = floor((width + EmojisPickerView.Const.interitemSpacing) / (EmojisPickerView.Const.itemSize.width + EmojisPickerView.Const.interitemSpacing))
        let lineCountEmoji = ceil(CGFloat(TrackerSettingsViewController.emojis.count) / lineItemCountEmoji)
        let emojiPickerHeight = (EmojisPickerView.Const.itemSize.height + EmojisPickerView.Const.lineSpacing) * lineCountEmoji - EmojisPickerView.Const.lineSpacing + EmojisPickerView.Const.headerHeight + EmojisPickerView.Const.sectionTopInset
        return emojiPickerHeight
    }
    
    private static func calculateColorPickerHeight() -> CGFloat {
        let width = UIScreen.main.bounds.width - 2 * Const.pickersHorizontalInsets
        let lineItemCountColors = floor((width + ColorsPickerView.Const.interitemSpacing) / (ColorsPickerView.Const.itemSize.width + ColorsPickerView.Const.interitemSpacing))
        let lineCountColors = ceil(CGFloat(TrackerSettingsViewController.colors.count) / lineItemCountColors)
        let colorPickerHeight = (ColorsPickerView.Const.itemSize.height + ColorsPickerView.Const.lineSpacing) * lineCountColors - ColorsPickerView.Const.lineSpacing + ColorsPickerView.Const.headerHeight + ColorsPickerView.Const.sectionTopInset
        return colorPickerHeight
    }
}

extension TrackerSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitTypeButtons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackerSettingsTableViewCell.reuseID, for: indexPath)
        guard let settingsCell = cell as? TrackerSettingsTableViewCell else { return cell }
        settingsCell.configure(with: habitTypeButtons[indexPath.row], isLast: indexPath.row == habitTypeButtons.count - 1)
        return settingsCell
    }
}

extension TrackerSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let model = CategoryListModel()
            let viewModel = CategoryListViewModel(model: model)
            viewModel.selectedCategory = currentSettings.categoryTitle
            let categoryListViewController = CategoryListViewController(viewModel: viewModel)
            categoryListViewController.onUserDidSelectCategory = { [weak categoryListViewController] categoryTitle in
                self.habitTypeButtons[0].subTitle = categoryTitle
                self.currentSettings.categoryTitle = categoryTitle
                tableView.reloadData()
                categoryListViewController?.dismiss(animated: true)
            }
            present(categoryListViewController, animated: true)
        case 1:
            let scheduleViewController = ScheduleViewController(enabledWeekDays: currentSettings.daysOfWeek)
            scheduleViewController.onUserDidSelectSchedule = { [weak scheduleViewController] enabledDays in
                self.currentSettings.daysOfWeek = enabledDays
                self.habitTypeButtons[1].subTitle = subtitleFrom(enabledDays: enabledDays)
                tableView.reloadData()
                scheduleViewController?.dismiss(animated: true)
            }
            present(scheduleViewController, animated: true)
        default:
            return
        }
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

private func subtitleFrom(enabledDays: Set<Tracker.WeekDay>) -> String {
    if enabledDays == Set(Tracker.WeekDay.allCases) {
        return "Каждый день"
    } else {
        return enabledDays
            .map {
                $0.shortName
            }.joined(separator: ", ")
    }
}
