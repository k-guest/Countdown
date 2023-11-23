import SwiftUI

struct ContentView: View {
    @StateObject var eventsViewModel = EventsViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Countdown")
                        .padding(.top, 15)
                        .padding(.bottom, 10)
                        .font(.system(size: 32))
                        .bold()
                    AsyncImage(url: URL(string: "https://cdn-icons-png.flaticon.com/512/3845/3845176.png?ga=GA1.1.1490056685.1700553608"), scale: 12.5)
                }
                Text("Mes événements :")
                    .padding(.bottom, 15)
                    .bold()
                List {
                    ForEach(eventsViewModel.sortedEvents) { event in
                        NavigationLink(
                            destination: EventDetail(event: event, eventsViewModel: eventsViewModel),
                            label: {
                                EventRow(eventsViewModel: eventsViewModel, event: event)
                            }
                        )
                        .padding(.trailing)
                        .background(event.color)
                    }
                    .listRowInsets(EdgeInsets())
                }.listStyle(PlainListStyle())
                NavigationLink(destination: AddEventView(eventsViewModel: eventsViewModel)) {
                    if colorScheme == .dark {
                        Image(systemName: "plus")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 32)
                            .background(Color(.white))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .font(.system(size: 24))
                            .bold()
                    } else {
                        Image(systemName: "plus")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 32)
                            .background(Color(.black))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.system(size: 24))
                            .bold()
                    }
                }.padding(.top, 15)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
