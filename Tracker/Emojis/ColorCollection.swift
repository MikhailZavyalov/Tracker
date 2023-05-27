import UIKit

class ColorCollection: UIViewController {
    let colorsForHabit: [UIColor] = [
        .red, .green, .blue, .systemPink, .yellow, .purple,
        .orange, .gray
    ]
    
    var colors: [String] = []
    
    private let collectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(EmojiAndColorCollectionViewCell.self, forCellWithReuseIdentifier: "colorsCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc
    private func addNextEmoji() {
        guard colorsForHabit.count < colorsForHabit.count else { return }
        
        var nextColorIndex = colorsForHabit.count
        colors.append(colors[nextColorIndex])
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [IndexPath(item: nextColorIndex, section: 0)])
        }
    }
    
    func setupConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}

extension ColorCollection: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsForHabit.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "emojiCell",
            for: indexPath) as? EmojiAndColorCollectionViewCell
        
        cell?.labelView.backgroundColor = colorsForHabit[indexPath.row]
        return cell!
    }
}

extension ColorCollection: UICollectionViewDelegate {
    
}

extension ColorCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}

