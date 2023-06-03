import UIKit

final class CategoryTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    
    private let accessoryImageView: UIImageView = {
        let accessoryImageView = UIImageView()
        accessoryImageView.image = UIImage(named: "checkmark")
        return accessoryImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = Colors.backgroundDay
        contentView.addSubview(accessoryImageView)
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: CategoryCellModel) {
        titleLabel.text = model.title
        accessoryImageView.isHidden = !model.isSelected
    }
    
    private func setupConstraints() {
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            accessoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.7),
            accessoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 14.3),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 14.19)
        ]
        
        constraints.forEach {
            $0.priority = .defaultHigh
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}
