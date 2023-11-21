import SwiftUI

struct Event: Identifiable {
    var id = UUID()
    var name: String
    var color: Color
    var date: Date
    var selectedIconURL: URL
}

class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []

//    let availableIconsURLs = [
//        URL(string: "https://cdn-icons-png.flaticon.com/512/10353/10353827.png?ga=GA1.1.1490056685.1700553608")!,
//        URL(string: "https://cdn-icons-png.flaticon.com/512/723/723955.png?ga=GA1.1.1490056685.1700553608")!,
//        URL(string: "https://cdn-icons-png.flaticon.com/512/565/565415.png?ga=GA1.1.1490056685.1700553608")!,
//        URL(string: "https://cdn-icons-png.flaticon.com/512/4240/4240150.png?ga=GA1.1.1490056685.1700553608")!,
//        URL(string: "https://cdn-icons-png.flaticon.com/512/876/876817.png?ga=GA1.1.1490056685.1700553608")!,
//        URL(string: "https://cdn-icons-png.flaticon.com/512/254/254477.png?ga=GA1.1.1490056685.1700553608")!
//    ]

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

struct AddEventView: View {
    @ObservedObject var eventsViewModel: EventsViewModel

    @State private var eventName = ""
    @State private var selectedColor: Color = .blue
    @State private var eventDate = Date()
    @State private var selectedIconURL: URL = EventsViewModel().availableIconsURLs.first!

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Créer un événement")) {
                TextField("Nom de l'événement", text: $eventName)
                ColorPicker("Couleur de l'événement", selection: $selectedColor)
                DatePicker("Date de l'événement", selection: $eventDate, displayedComponents: .date)
                Picker("Icône de l'événement", selection: $selectedIconURL) {
                    ForEach(eventsViewModel.availableIconsURLs, id: \.self) { iconURL in
                        AsyncImage(url: iconURL) { image in
                            image
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                        } placeholder: {
                            Text("")
                        }
                    }
                }.pickerStyle(.navigationLink)
            }

            Section {
                Button("Ajouter") {
                    let newEvent = Event(name: eventName, color: selectedColor, date: eventDate, selectedIconURL: selectedIconURL)
                        eventsViewModel.events.append(newEvent)
                        presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationBarTitle("Ajouter un événement")
    }
}

struct EventRow: View {
    @ObservedObject var eventsViewModel: EventsViewModel
    var event: Event

    var body: some View {
        HStack {
            Image(systemName: "photo")
                .load(url: event.selectedIconURL)
                .frame(width: 30, height: 30)
                .padding(.leading)
            Text(event.name)
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

struct EventDetail: View {
    @State private var editedEventName: String
    @State private var editedColor: Color
    @State private var editedDate: Date
    @State private var editedIconURL: URL

    @State private var isEditing = false

    var event: Event
    var eventsViewModel: EventsViewModel

    init(event: Event, eventsViewModel: EventsViewModel) {
        self.event = event
        self.eventsViewModel = eventsViewModel
        _editedEventName = State(initialValue: event.name)
        _editedColor = State(initialValue: event.color)
        _editedDate = State(initialValue: event.date)
        _editedIconURL = State(initialValue: event.selectedIconURL)
    }

    var body: some View {
        if isEditing {
            Form {
                Section(header: Text("Modifier un événement")) {
                    TextField("Nom de l'événement", text: $editedEventName)
                        .font(.largeTitle)
                        .padding()
                    ColorPicker("Couleur de l'événement", selection: $editedColor)
                    DatePicker("Date de l'événement", selection: $editedDate, displayedComponents: .date)
                    Picker("Icône de l'événement", selection: $editedIconURL) {
                        ForEach(eventsViewModel.availableIconsURLs, id: \.self) { iconURL in
                            AsyncImage(url: iconURL) { image in
                                image
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            } placeholder: {
                                Text("Icône")
                            }
                        }
                    }.pickerStyle(.navigationLink)
                }.navigationBarTitle("Modification de l'événement")
                Section {
                    Button("Sauvegarder") {
                        let editedEvent = Event(id: event.id, name: editedEventName, color: editedColor, date: editedDate, selectedIconURL: editedIconURL)
                        eventsViewModel.updateEvent(event: editedEvent)
                        isEditing.toggle()
                    }.foregroundColor(.green)
                }
            }
        } else {
            Form {
                Section(header: Text("Détails de l'événement")) {
                    Text(editedEventName)
                        .font(.largeTitle)
                    Text("Date : \(formattedDate(for: editedDate))")
                        .foregroundColor(.gray)
                }
                Section {
                    Button("Modifier") {
                        isEditing.toggle()
                    }.foregroundColor(.blue)
                    Button("Supprimer") {
                        if let index = eventsViewModel.events.firstIndex(where: { $0.id == event.id }) {
                            eventsViewModel.events.remove(at: index)
                        }
                    }.foregroundColor(.red)
                }
            }
            .navigationBarTitle(Text(editedEventName), displayMode: .inline)
        }
    }

    private func formattedDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long

        let dateString = dateFormatter.string(from: date)
        return dateString
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
