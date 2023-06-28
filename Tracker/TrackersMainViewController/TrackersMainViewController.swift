import UIKit
import SwiftUI

class TrackersMainViewController: UIViewController {
    fileprivate struct Filters {
        var date: Date
        var searchText: String?
    }
    
    private var trackerRecords: [TrackerRecord] = [] {
        didSet {
            updateUI()
        }
    }
    
    private var currentFilters = Filters(date: Date()) {
        didSet {
            updateUI()
        }
    }
    
    private var trackerCategories: [TrackerCategory] = [] {
        didSet {
            updateUI()
        }
    }
    
    private var visibleTrackerCategories: [TrackerCategory] {
        trackerCategories.filter { !$0.visibleTrackers(using: Filters(date: currentFilters.date)).isEmpty }
    }
    
    private var filteredTrackerCategories: [TrackerCategory] {
        trackerCategories.filter { !$0.visibleTrackers(using: currentFilters).isEmpty
        }
    }
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let geometricParams = GeometricParams(cellCount: 2, leftInset: 10, rightInset: 10, cellSpacing: 10)
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        return datePicker
    }()
    
    private let uiSearchTextField: UISearchTextField = {
        let uiSearchTextField = UISearchTextField()
        uiSearchTextField.placeholder = "TrackersMainVC.searchField.placeHolder".localized
        uiSearchTextField.clearButtonMode = .never
        uiSearchTextField.tintColor = Colors.black
        return uiSearchTextField
    }()
    
    private let clearSearchFieldButton: UIButton = {
        let button = UIButton()
        button.setTitle("TrackersMainVC.clearSearchField.title".localized, for: .normal)
        button.backgroundColor = Colors.white
        button.setTitleColor(Colors.blue, for: .normal)
        button.titleLabel?.font = UIFont(name: "SF Pro", size: 17)
        button.isHidden = true
        return button
    }()
    
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.image = UIImage(named: "trackersIsEmptyLogo")
        view.text = "TrackersMainVC.emptyStateView.title".localized
        return view
    }()
    
    private let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = Colors.white
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }()
    
    private var observations: Set<NSKeyValueObservation> = []
    private let storage: CoreDataStorageProtocol

    init(storage: CoreDataStorageProtocol = CoreDataStorage.shared) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        observations.insert(
            storage.observeTrackerCategories { [weak self] categories in
                self?.trackerCategories = categories
            }
        )
        observations.insert(
            storage.observeTrackerRecords { [weak self] records in
                self?.trackerRecords = records
            }
        )
        
        view.backgroundColor = Colors.white
        collectionView.backgroundColor = Colors.white
        title = "TrackersMainVC.title".localized
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseID)
        collectionView.register(TrackerSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSectionHeaderView.reuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
        uiSearchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        uiSearchTextField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        uiSearchTextField.addTarget(self, action: #selector(textFieldEditingDidEndOnExit), for: .editingDidEndOnExit)
        clearSearchFieldButton.addTarget(self, action: #selector(clearSearchField), for: .touchUpInside)
        
        
        navBarConfig()
        setupConstraints()
        updateUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let params = EventParams(event: .open, screen: .main)
        Analytics.sendEvent(.mainScreenShow, params: params)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let params = EventParams(event: .close, screen: .main)
        Analytics.sendEvent(.mainScreenClose, params: params)
    }
    
    private func updateUI() {
        collectionView.reloadData()
        emptyStateView.isHidden = !filteredTrackerCategories.isEmpty
        if filteredTrackerCategories.isEmpty && !visibleTrackerCategories.isEmpty {
            emptyStateView.image = UIImage(named: "2")
            emptyStateView.text = "TrackersMainVC.emptyStateView.emptyTitle".localized
        } else {
            emptyStateView.image = UIImage(named: "trackersIsEmptyLogo")
            emptyStateView.text = "TrackersMainVC.emptyStateView.title".localized
        }
    }
    
    private func navBarConfig() {
        if let navBar = navigationController?.navigationBar {
            let rightButton = UIBarButtonItem(customView: datePicker)
            datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            navBar.topItem?.setRightBarButton(rightButton, animated: false)
            
            let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusTapped))
            navBar.topItem?.setLeftBarButton(leftButton, animated: false)
            navBar.topItem?.leftBarButtonItem?.tintColor = Colors.black
            navBar.backgroundColor = Colors.white
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func pinTracker(indexPath: IndexPath) {

    }

    private func editTracker(indexPath: IndexPath) {
        let params = EventParams(event: .click, screen: .main, item: .edit)
        Analytics.sendEvent(.mainScreenContextMenuEditTap, params: params)
    }

    private func deleteTracker(indexPath: IndexPath) {
        let params = EventParams(event: .click, screen: .main, item: .delete)
        Analytics.sendEvent(.mainScreenContextMenuDeleteTap, params: params)
    }
    
    private func setupConstraints() {
        
        let hStack = UIStackView(arrangedSubviews: [uiSearchTextField, clearSearchFieldButton])
        hStack.spacing = 5
        view.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        uiSearchTextField.translatesAutoresizingMaskIntoConstraints = false
        clearSearchFieldButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            hStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            hStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            hStack.heightAnchor.constraint(equalToConstant: 36),
        ])
        
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: uiSearchTextField.bottomAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
        ])
        
        view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            separator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            separator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
    }
    
    @objc
    private func plusTapped() {
        let params = EventParams(event: .click, screen: .main, item: .addTrack)
        Analytics.sendEvent(.mainScreenAddTrackerTap, params: params)
        let addNewTrackerViewController = AddNewTrackerViewController()
        addNewTrackerViewController.onNewTrackerCreated = { [weak self] tracker in
            try? self?.storage.add(tracker: tracker)
            addNewTrackerViewController.dismiss(animated: true)
        }
        present(addNewTrackerViewController, animated: true)
    }
    
    @objc
    private func dateChanged() {
        currentFilters.date = datePicker.date
    }
    
    @objc
    private func searchTextChanged() {
        currentFilters.searchText = uiSearchTextField.text
        if uiSearchTextField.text == "" {
            currentFilters.searchText = nil
        }
    }
    
    @objc
    private func textFieldDidBeginEditing() {
        let params = EventParams(event: .click, screen: .main, item: .filter)
        Analytics.sendEvent(.mainScreenFilterTap, params: params)
        clearSearchFieldButton.isHidden = false
    }
    
    @objc
    private func textFieldEditingDidEndOnExit() {
        uiSearchTextField.resignFirstResponder()
        if uiSearchTextField.text == "" || uiSearchTextField.text == nil {
            clearSearchFieldButton.isHidden = true
        }
    }
    
    @objc
    private func clearSearchField() {
        uiSearchTextField.text = nil
        currentFilters.searchText = nil
        uiSearchTextField.resignFirstResponder()
        clearSearchFieldButton.isHidden = true
    }
}

extension TrackersMainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredTrackerCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTrackerCategories[section].visibleTrackers(using: currentFilters).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseID,
            for: indexPath
        )
        guard let trackerCell = cell as? TrackerCollectionViewCell else {
            return cell
        }
        let tracker = filteredTrackerCategories[indexPath.section].visibleTrackers(using: currentFilters)[indexPath.item]
        
        let model = TrackerCollectionCellModel(
            tracker: tracker,
            trackerRecords: trackerRecords,
            chosenDate: currentFilters.date
        )
        
        trackerCell.configureWith(model: model)
        
        trackerCell.doneButtonAction = { [self] in
            let params = EventParams(event: .click, screen: .main, item: .track)
            Analytics.sendEvent(.mainScreenTrackerTap, params: params)

            guard
                tracker.daysOfWeek.contains(currentFilters.date.weekDay!)
            else {
                return
            }
            let record = TrackerRecord(trackerId: tracker.id, date: currentFilters.date)
            if trackerRecords.contains(record) {
                try! storage.delete(trackerRecord: record)
            } else {
                try! storage.add(trackerRecord: record)
            }
        }
        return trackerCell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSectionHeaderView.reuseID, for: indexPath)
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = supplementaryView as? TrackerSectionHeaderView
        else {
            return supplementaryView
        }
        headerView.text = filteredTrackerCategories[indexPath.section].name
        return headerView
    }
}

extension TrackersMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: collectionView.frame.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - geometricParams.paddingWidth
        let cellWidth =  availableWidth / CGFloat(geometricParams.cellCount)
        return CGSize(width: cellWidth, height: cellWidth * 3 / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: geometricParams.leftInset, bottom: 10, right: geometricParams.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return geometricParams.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return geometricParams.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }

        let indexPath = indexPaths[0]

        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Закрепить") { [weak self] _ in
                    self?.pinTracker(indexPath: indexPath)
                },
                UIAction(title: "Редактировать") { [weak self] _ in
                    self?.editTracker(indexPath: indexPath)
                },
                UIAction(title: "Удалить") { [weak self] _ in
                    self?.deleteTracker(indexPath: indexPath)
                },
            ])
        })
    }
}

private extension TrackerCategory {
    func visibleTrackers(using filters: TrackersMainViewController.Filters) -> [Tracker] {
        let result = trackers.filter { tracker in
            let weekDay = filters.date.weekDay
            let containsWeekDay = weekDay == nil ? false : tracker.daysOfWeek.contains(weekDay!)
            let containsText = filters.searchText == nil ? true : tracker.title.contains(filters.searchText!)
            return containsWeekDay && containsText
        }
        return result
    }
}

struct TrackersMainViewController_Previews: PreviewProvider {
    static var previews: some View {
        let vc = TrackersMainViewController()
        
        return UIViewRepresented(makeUIView: { _ in vc.view })
    }
}
