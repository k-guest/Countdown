import SwiftUI

struct ContentView: View {
    @ObservedObject var eventsViewModel = EventsViewModel()

    var body: some View {
        NavigationView {
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
            }
            .navigationBarItems(leading:
                HStack {
                    Text("Événements")
                        .font(.system(size: 32))
                        .bold()
                },
                trailing: NavigationLink(destination: AddEventView(eventsViewModel: eventsViewModel)) {
                    Image(systemName: "plus")
                        .padding([.vertical], 8)
                        .padding([.horizontal], 18)
                        .background(Color(.black))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.system(size: 20))
                        .bold()
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
