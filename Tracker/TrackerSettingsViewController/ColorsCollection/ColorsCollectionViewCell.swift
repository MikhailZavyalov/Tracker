import UIKit

final class ColorsCollectionViewCell: UICollectionViewCell {
    let color = UIView()
    
    let colorsForHabit: [UIColor] = [
        .red, .green, .blue, .systemPink, .yellow, .purple,
        .orange, .gray
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(color)
        color.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            color.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            color.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ColorsCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsForHabit.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "colorsCell",
            for: indexPath) as? ColorsCollectionViewCell
        
        cell?.color.backgroundColor = colorsForHabit[indexPath.row]
        return cell!
    }
}

extension ColorsCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}
