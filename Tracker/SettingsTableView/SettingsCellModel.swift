import UIKit

struct SettingsCellModel {
    let title: String
    let accessoryType: AccessoryType
    var switchValue: Bool
    
    enum AccessoryType {
        case arrow, `switch`
    }
}
