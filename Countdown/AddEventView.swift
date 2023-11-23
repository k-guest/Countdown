import SwiftUI

struct AddEventView: View {
    @ObservedObject var eventsViewModel: EventsViewModel

    @State private var eventName = ""
    @State private var eventDate = Date()
    @State private var selectedCustomColor: Color = EventsViewModel().colors.first!
    @State private var selectedIconURL: URL = EventsViewModel().availableIconsURLs.first!

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Créer un événement")) {
                TextField("Nom de l'événement", text: $eventName)
                DatePicker("Date de l'événement", selection: $eventDate, displayedComponents: .date)
                Picker("Couleur de l'événement", selection: $selectedCustomColor) {
                    ForEach(eventsViewModel.colors, id: \.self) { color in
                        Button(action: {
                            self.selectedCustomColor = color
                        }) {
                            Circle()
                                .fill(color)
                                .frame(width: 25, height: 25)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: self.selectedCustomColor == color ? 3 : 0)
                                )
                        }
                    }
                }.pickerStyle(.navigationLink)
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
                    let newEvent = Event(name: eventName, date: eventDate, color: selectedCustomColor, selectedIconURL: selectedIconURL)
                    eventsViewModel.events.append(newEvent)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationBarTitle("Ajouter un événement")
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(eventsViewModel: EventsViewModel())
    }
}
