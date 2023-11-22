import SwiftUI

struct AddEventView: View {
    @ObservedObject var eventsViewModel: EventsViewModel

    @State private var eventName = ""
    @State private var selectedColor: Color = .white
    @State private var eventDate = Date()
    @State private var selectedIconURL: URL = EventsViewModel().availableIconsURLs.first!

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Créer un événement")) {
                TextField("Nom de l'événement", text: $eventName)
                DatePicker("Date de l'événement", selection: $eventDate, displayedComponents: .date)
                ColorPicker("Couleur de l'événement", selection: $selectedColor)
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
