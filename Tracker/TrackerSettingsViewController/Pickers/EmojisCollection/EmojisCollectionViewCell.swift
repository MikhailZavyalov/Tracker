import UIKit

final class EmojisCollectionViewCell: UICollectionViewCell {
    private let emoji = UILabel()
 
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? Colors.lightGray : .clear
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 16
        
        contentView.addSubview(emoji)
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emoji.textAlignment = .center
        emoji.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        NSLayoutConstraint.activate([
            emoji.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emoji.widthAnchor.constraint(equalToConstant: 32),
            emoji.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(model: EmojisCollectionCellModel) {
        emoji.text = model.emoji
    }
}
