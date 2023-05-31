import UIKit
import SwiftUI

final class ScheduleTableViewCell: UITableViewCell {
    var onValueChanged: ((_ switchValue: Bool) -> Void)?
    
    private let titleLabel = UILabel()
    
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
        uiSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        contentView.backgroundColor = Colors.lightGray
        contentView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: ScheduleCellModel) {
        titleLabel.text = model.dayOfWeek.fullName
        uiSwitch.isOn = model.switchValue
    }
    
    @objc
    private func switchValueChanged() {
        onValueChanged?(uiSwitch.isOn)
    }
    
    
    private func setupConstraints() {
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            uiSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            uiSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
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

