import SwiftUI

struct ContentView: View {
    @StateObject var eventsViewModel = EventsViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Événements")
                    .padding(.top, 10)
                    .padding(.bottom, 15)
                    .font(.system(size: 24))
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
                    Image(systemName: "plus")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 32)
                        .background(Color(.black))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.system(size: 24))
                        .bold()
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
