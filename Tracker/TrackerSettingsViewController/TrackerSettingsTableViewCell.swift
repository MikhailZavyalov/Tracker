import UIKit

final class TrackerSettingsTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
       let title = UILabel()
        title.font = UIFont(name: "SF Pro", size: 17)
        return title
    }()
    
    private let subTitleLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.textColor = Colors.blackDay
        subTitleLabel.font = UIFont(name: "SF Pro", size: 17)
        return subTitleLabel
    }()
    
    private let arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "icon.chevron")
        return arrowImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(arrowImageView)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        contentView.backgroundColor = Colors.backgroundDay

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: TrackerSettingsCellModel) {
        titleLabel.text = model.title
        subTitleLabel.text = model.subTitle
        subTitleLabel.isHidden = model.subTitle == nil || model.subTitle?.isEmpty == true
    }
    
    private func setupConstraints() {
        let titleAndSubtitleStackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        contentView.addSubview(titleAndSubtitleStackView)
        titleAndSubtitleStackView.axis = .vertical
        titleAndSubtitleStackView.spacing = 0
        titleAndSubtitleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            titleAndSubtitleStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            titleAndSubtitleStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            titleAndSubtitleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleAndSubtitleStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 7),
            arrowImageView.heightAnchor.constraint(equalToConstant: 12),
        ]
        
        constraints.forEach {
            $0.priority = .defaultHigh
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}
