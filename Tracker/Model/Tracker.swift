import UIKit

class Tracker: NSObject, Codable {
    let id: UUID
    let color: Color
    let title: String
    let emoji: String
    let categoryTitle: String
    let daysOfWeek: Set<WeekDay>
    let creationDate: Date
    var isPinned: Bool
    
    internal init(id: UUID, color: Tracker.Color, title: String, emoji: String, categoryTitle: String, daysOfWeek: Set<Tracker.WeekDay>, creationDate: Date, isPinned: Bool) {
        self.id = id
        self.color = color
        self.title = title
        self.emoji = emoji
        self.categoryTitle = categoryTitle
        self.daysOfWeek = daysOfWeek
        self.creationDate = creationDate
        self.isPinned = isPinned
    }
    
    enum WeekDay: Codable, CaseIterable, Hashable {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }
    
    struct Color: Codable, Hashable {
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

extension Tracker.WeekDay {
    var fullName: String {
        switch self {
        case .monday:
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sunday:
            return "Воскресенье"
        }
    }
    
    var shortName: String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
}
