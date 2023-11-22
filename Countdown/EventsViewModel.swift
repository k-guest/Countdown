import SwiftUI

class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []

    let availableIconsURLs = [
        URL(string: "https://cdn-icons-png.flaticon.com/512/2052/2052723.png?ga=GA1.1.1490056685.1700553608")!,
        URL(string: "https://cdn-icons-png.flaticon.com/512/1350/1350222.png?ga=GA1.1.1490056685.1700553608")!,
        URL(string: "https://cdn-icons-png.flaticon.com/512/2454/2454297.png?ga=GA1.1.1490056685.1700553608")!,
        URL(string: "https://cdn-icons-png.flaticon.com/512/3418/3418886.png?ga=GA1.1.1490056685.1700553608")!,
        URL(string: "https://cdn-icons-png.flaticon.com/512/564/564046.png?ga=GA1.1.1490056685.1700553608")!,
        URL(string: "https://cdn-icons-png.flaticon.com/512/867/867319.png?ga=GA1.1.1490056685.1700553608")!
    ]

    var sortedEvents: [Event] {
        return events.sorted { $0.date < $1.date }
    }

    func updateEvent(event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
        }
    }
}
