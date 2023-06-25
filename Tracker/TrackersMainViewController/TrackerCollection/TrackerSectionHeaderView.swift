import UIKit

final class TrackerSectionHeaderView: UICollectionReusableView {
    static let reuseID = "TrackerSectionHeaderView"
    
    var leftInset: CGFloat = 20 {
        didSet {
            leftConstraint?.constant = leftInset
        }
    }
    var text: String? {
        didSet {
            titleLabel.text = text
        }
    }
    
    private let titleLabel = UILabel()
    private var leftConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.textColor = Colors.black
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        leftConstraint = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset)
        leftConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
