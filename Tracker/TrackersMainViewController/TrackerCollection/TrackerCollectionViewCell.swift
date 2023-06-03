import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    var doneButtonAction: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let colorView = UIView()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        label.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return label
    }()
    
    private let dateLabel = UILabel()
    private let doneButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17
        button.imageEdgeInsets = UIEdgeInsets(top: 11.72, left: 11.72, bottom: 11.72, right: 11.72)
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
        titleLabel.textColor = Colors.whiteDay
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
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
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(model: TrackerCollectionCellModel) {
        titleLabel.text = model.title
        colorView.backgroundColor = model.color
        emojiLabel.text = model.emoji
        dateLabel.text = "\(model.daysCompleted) дней"
        // для ревью - ниже использован "plus [black]" из SF Symbols, так как изображение белого цвета из макета скачивается пустым. Это наглядно видно по картинке "plus" в папке Assets
        doneButton.setImage(model.isCompleted ? UIImage(named: "done") : UIImage(named: "plus [black]"), for: .normal)
        doneButton.backgroundColor = model.isCompleted ? model.color.withAlphaComponent(0.7) : model.color
    }
    
    @objc private func doneButtonTapped() {
        doneButtonAction?()
    }
}
