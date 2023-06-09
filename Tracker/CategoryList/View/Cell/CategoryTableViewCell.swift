import UIKit

final class CategoryTableViewCell: UITableViewCell {
    private var viewModel: CategoryCellViewModel?
    private let titleLabel = UILabel()
    
    private let accessoryImageView: UIImageView = {
        let accessoryImageView = UIImageView()
        accessoryImageView.image = UIImage(named: "checkmark")
        return accessoryImageView
    }()
    
    private let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return separator
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = Colors.background
        contentView.addSubview(accessoryImageView)
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        contentView.backgroundColor = Colors.background
        contentView.layer.cornerRadius = 16
        contentView.addSubview(separator)
        selectionStyle = .none

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            accessoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.7),
            accessoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 14.3),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 14.19),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ]
        
        constraints.forEach {
            $0.priority = .defaultHigh
        }
        
        NSLayoutConstraint.activate(constraints)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.$isSelected.unbind()
        viewModel = nil
    }
    
    func configure(with viewModel: CategoryCellViewModel, isFirst: Bool, isLast: Bool) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        viewModel.$isSelected.bind(executeInitially: true) { [weak self] isSelected in
            self?.accessoryImageView.isHidden = !isSelected
        }
        separator.isHidden = false
        contentView.layer.maskedCorners = []
        if isFirst {
            contentView.layer.maskedCorners.formUnion([.layerMaxXMinYCorner, .layerMinXMinYCorner])
        }
        if isLast {
            contentView.layer.maskedCorners.formUnion([.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
            separator.isHidden = true
        }
    }
}
