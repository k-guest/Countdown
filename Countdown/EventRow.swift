import SwiftUI

struct EventRow: View {
    @ObservedObject var eventsViewModel: EventsViewModel
    var event: Event

    var body: some View {
        HStack {
            Image(systemName: "photo")
                .load(url: event.selectedIconURL)
                .frame(width: 25, height: 25)
                .padding(.leading)
            Text(event.name)
                .foregroundColor(.black)
            Spacer()
            VStack {
                Text("\(daysRemaining(for: event.date))")
                    .foregroundColor(.gray)
                Text("Jours Restants")
                    .foregroundColor(.gray)
            }.padding(10)
        }
    }

    private func daysRemaining(for date: Date) -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.day], from: currentDate, to: date)
        return components.day ?? 0
    }
}

extension Image {
    func load(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                Image(systemName: "photo")
            @unknown default:
                Image(systemName: "photo")
            }
        }
    }
}
