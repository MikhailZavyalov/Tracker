import UIKit

class EmojiMixerViewController: UIViewController {
    let emojisArray = [ "🍇", "🍈", "🍉", "🍊", "🍋", "🍌",
                   "🍍", "🥭", "🍎", "🍏", "🍐", "🍒",
                   "🍓", "🫐", "🥝", "🍅", "🫒", "🥥",
                   "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️"
    ]
    
    var emojis: [String] = []
    
    private let collectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "emojiCell")
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
        guard emojisArray.count < emojisArray.count else { return }
        
        var nextEmojisIndex = emojisArray.count
        emojis.append(emojis[nextEmojisIndex])
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: [IndexPath(item: nextEmojisIndex, section: 0)])
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

extension EmojiMixerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojisArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "emojiCell",
            for: indexPath) as? EmojiCollectionViewCell
        
        cell?.emogiLabelView.text = emojisArray[indexPath.row]
        return cell!
    }
}

extension EmojiMixerViewController: UICollectionViewDelegate {
    
}

extension EmojiMixerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}

