import YandexMobileMetrica

enum EventName: String {
    case mainScreenShow = "MainScreen.Show"
    case mainScreenClose = "MainScreen.Close"
    case mainScreenAddTrackerTap = "MainScreen.AddTrackerTap"
    case mainScreenTrackerTap = "MainScreen.TrackerTap"
    case mainScreenFilterTap = "MainScreen.FilterTap"
    case mainScreenContextMenuEditTap = "MainScreen.ContextMenuEditTap"
    case mainScreenContextMenuDeleteTap = "MainScreen.ContextMenuDeleteTap"
}

struct EventParams {
    enum Event: String {
        case open
        case close
        case click
    }

    enum Screen: String {
        case main = "Main"
    }

    enum Item: String {
        case addTrack = "add_track"
        case track
        case filter
        case edit
        case delete
    }

    let event: Event
    let screen: Screen
    let item: Item?

    init(event: EventParams.Event, screen: EventParams.Screen, item: EventParams.Item? = nil) {
        self.event = event
        self.screen = screen
        self.item = item
    }
}

final class Analytics {
    static func sendEvent(_ name: EventName, params: EventParams) {
        YMMYandexMetrica.reportEvent(name.rawValue, parameters: params.payload)
    }
}

extension EventParams {
    var payload: [AnyHashable : Any] {
        var result: [String: String] = [
            "event": event.rawValue,
            "screen": screen.rawValue
        ]
        if let item {
            result["item"] = item.rawValue
        }

        return result
    }
}
