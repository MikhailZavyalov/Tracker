import Foundation

extension Date {
    var weekDay: Tracker.WeekDay? {
        let dateComponents = Calendar.current.dateComponents([.weekday], from: self)
        guard let dateWeekDay = dateComponents.weekday else { return nil }
        switch dateWeekDay {
        case 1:
            return .sunday
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thursday
        case 6:
            return .friday
        case 7:
            return .saturday
        default:
            return nil
        }
    }
}
