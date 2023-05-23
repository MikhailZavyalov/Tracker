import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    var doneButtonAction: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let colorView = UIView()
    private let emojiLabel = UILabel()
    private let dateLabel = UILabel()
    private let doneButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 15
        
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = "1 day"
        
        contentView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("✅", for: .normal)
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(contentView.frame.height * 1 / 3)),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 10),
            emojiLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 0),
            emojiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(contentView.frame.height * 3 / 4)),
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.frame.height * 1 / 3),
            titleLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 10),
            dateLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 0),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(contentView.frame.width / 2)),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            doneButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 0),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            doneButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.frame.width / 2)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(model: Tracker) {
        titleLabel.text = model.title
        colorView.backgroundColor = model.color.uiColor
        emojiLabel.text = model.emoji
        dateLabel.text = model.dateLabel
    }
}
