import SwiftUI

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
