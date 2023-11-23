import SwiftUI

struct EventDetail: View {
    @State private var editedEventName: String
    @State private var editedDate: Date
    @State private var editedColor: Color
    @State private var editedIconURL: URL

    @State private var isEditing = false
    
    @State private var randomLorem: String?

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
                    TextField("Nom de l'événement :", text: $editedEventName)
                    DatePicker("Date de l'événement :", selection: $editedDate, displayedComponents: .date)
                    Picker("Couleur de l'événement :", selection: $editedColor) {
                        ForEach(eventsViewModel.colors, id: \.self) { color in
                            Button(action: {
                                self.editedColor = color
                            }) {
                                Circle()
                                    .fill(color)
                                    .frame(width: 25, height: 25)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: self.editedColor == color ? 3 : 0)
                                    )
                            }
                        }
                    }.pickerStyle(.navigationLink)
                    Picker("Icône de l'événement :", selection: $editedIconURL) {
                        ForEach(eventsViewModel.availableIconsURLs, id: \.self) { iconURL in
                            AsyncImage(url: iconURL) { image in
                                image
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            } placeholder: {
                                Text("Icône")
                            }
                        }
                    }.pickerStyle(.navigationLink)
                }.navigationBarTitle("Modification de l'événement")
                Section {
                    Button("Sauvegarder") {
                        let editedEvent = Event(id: event.id, name: editedEventName, date: editedDate, color: editedColor, selectedIconURL: editedIconURL)
                        eventsViewModel.updateEvent(event: editedEvent)
                        isEditing.toggle()
                    }.foregroundColor(.green)
                }
            }
        } else {
            Form {
                Section(header: Text("Détails de l'événement")) {
                    Text("Nom : \(editedEventName)")
                    Text("Date : \(formattedDate(for: editedDate))")
                    HStack {
                        Text("Couleur :")
                        Circle()
                            .fill(editedColor)
                            .frame(width: 25, height: 25)
                    }
                    HStack {
                        Text("Icône :")
                        AsyncImage(url: editedIconURL) { image in
                            image
                                .resizable()
                                .frame(width: 25, height: 25)
                        } placeholder: {
                            Text("")
                        }
                    }
                }
                // Nouvelle section pour afficher un texte aléatoire depuis l'API
                // L'objectif de la connexion à l'API est de générer un texte personnalisé en fonction des éléments sélectionnés lors de la création d'un événement.
                // Exemple : Création d'un événement pour la sortie d'un film au cinéma, identifiable par l'icône Popcorn.
                // Cette sélection sera identifiable grâce à une mise à jour de l'application.
                // Le message affiché sera le suivant : "Le 28/02/2023, ne manquez pas la sortie tant attendue du film Dune: Partie 2 au cinéma !"
                Section(header: Text("Connexion API")) {
                    if let randomLorem = randomLorem {
                        Text(randomLorem)
                    } else {
                        Text("Chargement du texte...")
                            .onAppear {
                                fetchRandomLorem()
                            }
                    }
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
    
    private func fetchRandomLorem() {
        guard let url = URL(string: "https://baconipsum.com/api/?type=all-meat&sentences=1&start-with-lorem=1") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([String].self, from: data)
                    if let lorem = decodedResponse.first {
                        DispatchQueue.main.async {
                            self.randomLorem = lorem
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}
