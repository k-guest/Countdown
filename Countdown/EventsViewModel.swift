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
    
    let colors: [Color] = [
        Color(red: 214/255, green: 226/255, blue: 252/255),
        Color(red: 214/255, green: 202/255, blue: 250/255),
        Color(red: 244/255, green: 184/255, blue: 177/255),
        Color(red: 252/255, green: 237/255, blue: 215/255),
        Color(red: 226/255, green: 238/255, blue: 214/255),
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
