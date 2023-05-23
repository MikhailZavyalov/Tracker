import UIKit
import SwiftUI

final class SettingsTableViewCell: UITableViewCell {
    var onValueChanged: ((_ switchValue: Bool) -> Void)?
    
    private let titleLabel = UILabel()
    
    private let accessoryImageView: UIImageView = {
        let accessoryImageView = UIImageView()
        accessoryImageView.image = .checkmark
        return accessoryImageView
    }()
    private let uiSwitch: UISwitch = {
       let uiSwitch = UISwitch()
        uiSwitch.onTintColor = .blue
        return uiSwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        uiSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(uiSwitch)
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .lightGray
        contentView.addSubview(accessoryImageView)
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: SettingsCellModel) {
        titleLabel.text = model.title
        uiSwitch.isOn = model.switchValue
        [accessoryImageView, uiSwitch].forEach { $0.isHidden = true }
        switch model.accessoryType {
        case .switch:
            uiSwitch.isHidden = false
        case .arrow:
            accessoryImageView.isHidden = false
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
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            uiSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            uiSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            accessoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            accessoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 30),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 30),
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
