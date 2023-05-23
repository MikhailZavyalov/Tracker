import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    let emogiLabelView = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(emogiLabelView)
        emogiLabelView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emogiLabelView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emogiLabelView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
