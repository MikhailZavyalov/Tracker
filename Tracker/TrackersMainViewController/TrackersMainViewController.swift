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
        trackerCategories.filter { !$0.visibleTrackers(using: currentFilters).isEmpty }
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
        return uiSearchTextField
    }()
    
    var trackersCollectionIsEmptyImage: UIImageView = {
        let image = UIImage(named: "trackersIsEmptyLogo")!
        var imageView = UIImageView(image: image)
        return imageView
    }()
    
    var trackersCollectionIsEmptyLabel: UILabel = {
        var label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont(name: "SF Pro", size: 12)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackerCategories = Storage.trackerCategories
        trackerRecords = Storage.trackerRecords
        
        view.backgroundColor = Colors.whiteDay
        title = "Трекеры"
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseID)
        collectionView.register(TrackerSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSectionHeaderView.reuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
        uiSearchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        
        navBarConfig()
        setupConstraints()
        updateUI()
    }
    
    private func updateUI() {
        collectionView.reloadData()
        trackersCollectionIsEmptyImage.isHidden = !visibleTrackerCategories.isEmpty
        trackersCollectionIsEmptyLabel.isHidden = !visibleTrackerCategories.isEmpty
    }
    
    private func navBarConfig() {
        if let navBar = navigationController?.navigationBar {
            let rightButton = UIBarButtonItem(customView: datePicker)
            datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            navBar.topItem?.setRightBarButton(rightButton, animated: false)
            
            let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusTapped))
            navBar.topItem?.setLeftBarButton(leftButton, animated: false)
            navBar.topItem?.leftBarButtonItem?.tintColor = Colors.blackDay
            navBar.backgroundColor = Colors.whiteDay
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupConstraints() {
        view.addSubview(uiSearchTextField)
        uiSearchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uiSearchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            uiSearchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            uiSearchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            uiSearchTextField.heightAnchor.constraint(equalToConstant: 36)
        ])
        uiSearchTextField.placeholder = "Поиск"
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: uiSearchTextField.bottomAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        view.addSubview(trackersCollectionIsEmptyImage)
        trackersCollectionIsEmptyImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersCollectionIsEmptyLabel)
        trackersCollectionIsEmptyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackersCollectionIsEmptyImage.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            trackersCollectionIsEmptyImage.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            trackersCollectionIsEmptyImage.heightAnchor.constraint(equalToConstant: 80),
            trackersCollectionIsEmptyImage.widthAnchor.constraint(equalToConstant: 80),
            trackersCollectionIsEmptyLabel.topAnchor.constraint(equalTo: trackersCollectionIsEmptyImage.bottomAnchor, constant: 8),
            trackersCollectionIsEmptyLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            trackersCollectionIsEmptyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackersCollectionIsEmptyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    @objc
    private func plusTapped() {
        let addNewTrackerViewController = AddNewTrackerViewController()
        addNewTrackerViewController.onNewTrackerCreated = { tracker in
            guard let categoryIndex = Storage.trackerCategories.firstIndex(where: { category in
                category.name == tracker.categoryTitle
            }) else {
                return
            }
            Storage.trackerCategories[categoryIndex].trackers.append(tracker)
            self.trackerCategories = Storage.trackerCategories
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
}

extension TrackersMainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleTrackerCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleTrackerCategories[section].visibleTrackers(using: currentFilters).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseID,
            for: indexPath
        )
        guard let trackerCell = cell as? TrackerCollectionViewCell else {
            return cell
        }
        let tracker = visibleTrackerCategories[indexPath.section].visibleTrackers(using: currentFilters)[indexPath.item]
        
        let model = TrackerCollectionCellModel(
            tracker: tracker,
            trackerRecords: trackerRecords,
            chosenDate: currentFilters.date
        )
        
        trackerCell.configureWith(model: model)
        
        trackerCell.doneButtonAction = { [self] in
            guard
//            Calendar.current.isDateInToday(currentFilters.date)
                     tracker.daysOfWeek.contains(datePicker.date.weekDay!)
            else {
                return
            }
            let record = TrackerRecord(trackerId: tracker.id, date: currentFilters.date)
            if trackerRecords.contains(record) {
                Storage.trackerRecords.removeAll { $0 == record }
            } else {
                Storage.trackerRecords.append(record)
            }
            trackerRecords = Storage.trackerRecords
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
        headerView.titleLabel.text = visibleTrackerCategories[indexPath.section].name
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
}

private extension TrackerCategory {
    func visibleTrackers(using filters: TrackersMainViewController.Filters) -> [Tracker] {
        let result = trackers.filter { tracker in
            let weekDay = filters.date.weekDay
            let containsWeekDay = weekDay == nil ? false : tracker.daysOfWeek.contains(weekDay!)
            let isToday = Calendar.current.isDateInToday(filters.date)
            let containsText = filters.searchText == nil ? true : tracker.title.contains(filters.searchText!)
            return (containsWeekDay || isToday) && containsText
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
