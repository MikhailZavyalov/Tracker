import UIKit

enum Colors {
    static let white = UIColor(named: "White") ?? .white
    static let black = UIColor(named: "Black") ?? .black
    static let background = UIColor(named: "Background") ?? .darkGray
    static let gray = UIColor(named: "Gray") ?? .gray
    static let lightGray = UIColor(named: "Light Gray") ?? .lightGray
    static let red = UIColor(named: "Red") ?? .red
    static let blue = UIColor(named: "Blue") ?? .blue
    static let uiSwitchBlue = UIColor(named: "UISwitch [blue]") ?? .blue
}

enum ColorSelection: String, CaseIterable {
    case colorSelection1 = "[1]red"
    case colorSelection2 = "[2]orange"
    case colorSelection3 = "[3]blue"
    case colorSelection4 = "[4]purple"
    case colorSelection5 = "[5]green"
    case colorSelection6 = "[6]violet"
    case colorSelection7 = "[7]pink"
    case colorSelection8 = "[8]blue"
    case colorSelection9 = "[9]green"
    case colorSelection10 = "[10]purple"
    case colorSelection11 = "[11]red"
    case colorSelection12 = "[12]pink"
    case colorSelection13 = "[13]orange"
    case colorSelection14 = "[14]blue"
    case colorSelection15 = "[15]violet"
    case colorSelection16 = "[16]violet"
    case colorSelection17 = "[17]violet"
    case colorSelection18 = "[18]green"
}
