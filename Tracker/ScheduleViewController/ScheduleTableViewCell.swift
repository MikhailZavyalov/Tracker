import UIKit
import SwiftUI

final class ScheduleTableViewCell: UITableViewCell {
    var onValueChanged: ((_ switchValue: Bool) -> Void)?
    
    private let titleLabel = UILabel()
    
    private let uiSwitch: UISwitch = {
       let uiSwitch = UISwitch()
        uiSwitch.onTintColor = Colors.uiSwitchBlue
        return uiSwitch
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
        
        uiSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(uiSwitch)
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        contentView.backgroundColor = Colors.backgroundDay
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        contentView.addSubview(separator)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: ScheduleCellModel, isFirst: Bool, isLast: Bool) {
        titleLabel.text = model.dayOfWeek.fullName
        uiSwitch.isOn = model.switchValue
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
    
    @objc
    private func switchValueChanged() {
        onValueChanged?(uiSwitch.isOn)
    }
    
    
    private func setupConstraints() {
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            uiSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            uiSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ]
        
        constraints.forEach {
            $0.priority = .defaultHigh
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}

//struct SettingsTableViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        return UIViewRepresented(makeUIView: { _ in SettingsTableViewCell(style: .default, reuseIdentifier: nil) })
//    }
//}

