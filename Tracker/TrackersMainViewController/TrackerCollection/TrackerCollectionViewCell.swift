import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    var doneButtonAction: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let colorView = UIView()
    private let pinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pin.fill")?
            .withTintColor(Colors.white)
            .withRenderingMode(.alwaysOriginal)
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 12))
        imageView.preferredSymbolConfiguration = config
        return imageView
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let dateLabel = UILabel()
    private let doneButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 16
        
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = Colors.white
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        contentView.addSubview(pinImage)
        pinImage.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 90),
            colorView.widthAnchor.constraint(equalToConstant: 167),

            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 10),
            emojiLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 0),
            emojiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(contentView.frame.height * 3 / 4)),
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 10),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44),
            titleLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),

            dateLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -8),
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),

            doneButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            doneButton.heightAnchor.constraint(equalToConstant: 34),
            doneButton.widthAnchor.constraint(equalToConstant: 34),

            pinImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            pinImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ]

        constraints.forEach {
            $0.priority = .defaultHigh
        }

        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(model: TrackerCollectionCellModel) {
        titleLabel.text = model.title
        colorView.backgroundColor = model.color
        emojiLabel.text = model.emoji
        dateLabel.text = String(format: "TrackerCollectionViewCell.dataLabel.text".localized, model.daysCompleted)
        doneButton.setImage(model.isCompleted ? UIImage(named: "done") : UIImage(named: "plus [black]"), for: .normal)
        doneButton.backgroundColor = model.isCompleted ? model.color.withAlphaComponent(0.7) : model.color
        pinImage.isHidden = !model.isPinned
    }
    
    @objc private func doneButtonTapped() {
        doneButtonAction?()
    }
}
