import UIKit

final class EmojisPickerView: UIView {
    enum Const {
        static let headerHeight: CGFloat = 20
        static let sectionTopInset: CGFloat = 24
        static let itemSize: CGSize = CGSize(width: 52, height: 52)
        static let interitemSpacing: CGFloat = 5
        static let lineSpacing: CGFloat = 0
    }
    
    var didPickEmoji: ((String) -> Void)?
    
    private let collectionView: UICollectionView = {
        let layout = PickerFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 52, height: 52)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let emojiCellModels: [EmojisCollectionCellModel]
    
    init(emojis: [String]) {
        emojiCellModels = emojis.map { EmojisCollectionCellModel(emoji: $0) }
        super.init(frame: .zero)
        collectionView.backgroundColor = Colors.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmojisCollectionViewCell.self, forCellWithReuseIdentifier: EmojisCollectionViewCell.reuseID)
        collectionView.register(TrackerSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSectionHeaderView.reuseID)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func selectEmoji(_ emoji: String, animated: Bool = false) {
        guard let index = emojiCellModels.firstIndex(where: { $0.emoji == emoji }) else {
            return
        }
        collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: animated, scrollPosition: .centeredHorizontally)
    }
    
    private func setupConstraints() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}

extension EmojisPickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiCellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EmojisCollectionViewCell.reuseID,
            for: indexPath)
        
        guard let emojisCell = cell as? EmojisCollectionViewCell else { return cell }
        
        emojisCell.configureWith(model: emojiCellModels[indexPath.row])
        return emojisCell
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
        headerView.text = "Emoji"
        headerView.leftInset = 10
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Const.sectionTopInset, left: 0, bottom: 0, right: 0)
    }
}

extension EmojisPickerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didPickEmoji?(emojiCellModels[indexPath.row].emoji)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: collectionView.frame.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}
