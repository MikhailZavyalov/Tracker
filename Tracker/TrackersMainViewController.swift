import UIKit
import SwiftUI

class TrackersMainViewController: UIViewController {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let geometricParams = GeometricParams(cellCount: 2, leftInset: 10, rightInset: 10, cellSpacing: 10)
    private let colors: [UIColor] = [.red, .blue, .green, .yellow]
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        return datePicker
    }()
    
    private let uiSearchTextField: UISearchTextField = {
        let uiSearchTextField = UISearchTextField()
        //        uiSearchTextFiel.delegate = UITextFieldDelegate
        return uiSearchTextField
    }()
    
    private let trackerCategories: [TrackerCategory] = [
        TrackerCategory(name: "Knight", trackers: [
            Tracker(id: UUID(), color: .init(uiColor: .yellow), title: "Sword", emoji: "😀", dateLabel: "1 day", daysOfWeek: [.monday]),
            Tracker(id: UUID(), color: .init(uiColor: .green), title: "Shield", emoji: "😘", dateLabel: "2 days", daysOfWeek: [.monday])
        ]),
        
        TrackerCategory(name: "Kittens", trackers: [
            Tracker(id: UUID(), color: .init(uiColor: .red), title: "Eat", emoji: "😈", dateLabel: "Everyday", daysOfWeek: [.monday])
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Трекеры"
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseID)
        collectionView.register(TrackerSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSectionHeaderView.reuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        navBarConfig()
        setupConstraints()
    }
    
    private func navBarConfig() {
        if let navBar = navigationController?.navigationBar {
            let rightButton = UIBarButtonItem(customView: datePicker)
            datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            navBar.topItem?.setRightBarButton(rightButton, animated: false)
            
            let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusTapped))
            navBar.topItem?.setLeftBarButton(leftButton, animated: false)
            navBar.backgroundColor = .white
        }
    }
    
    private func setupConstraints() {
        view.addSubview(uiSearchTextField)
        uiSearchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uiSearchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            uiSearchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            uiSearchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            uiSearchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        uiSearchTextField.placeholder = "Поиск"
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: uiSearchTextField.bottomAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    @objc
    private func plusTapped() {
        present(AddNewTrackerViewController(), animated: true)
    }
    
    private func dateTapped() {
        datePicker.isHidden.toggle()
    }
    
    @objc
    private func dateChanged() {
        print(datePicker.date)
    }
}

extension TrackersMainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackerCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackerCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseID,
            for: indexPath
        )
        guard let trackerCell = cell as? TrackerCollectionViewCell else { return cell }
        trackerCell.configureWith(model: trackerCategories[indexPath.section].trackers[indexPath.item])
        trackerCell.doneButtonAction = {
            // action for button
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
        headerView.titleLabel.text = trackerCategories[indexPath.section].name
        return headerView
    }
}

extension TrackersMainViewController: UICollectionViewDelegate {
    
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

struct TrackersMainViewController_Previews: PreviewProvider {
  static var previews: some View {
    let vc = TrackersMainViewController()
      
    return UIViewRepresented(makeUIView: { _ in vc.view })
  }
}

