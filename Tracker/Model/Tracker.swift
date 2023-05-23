import UIKit

struct Tracker: Codable {
    let id: UUID
    let color: Color
    let title: String
    let emoji: String
    let dateLabel: String
    let daysOfWeek: [WeekDay]
    
    enum WeekDay: Codable {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }
    
    struct Color: Codable {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        
        var uiColor: UIColor {
            UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
        
        init(uiColor: UIColor) {
            let ciColor = CIColor(color: uiColor)
            red = ciColor.red
            green = ciColor.green
            blue = ciColor.blue
        }
    }
}

