//
//  ContentView.swift
//  Countdown
//
//  Created by Kevin Guest on 20/11/2023.
//

import SwiftUI

struct Event: Identifiable {
    var id = UUID()
    var name: String
    var color: Color
    var date: Date
    var selectedIcon: String
}

class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []

    let availableIcons = ["star", "birthday.cake", "airplane", "movieclapper", "music.mic"]

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
                ForEach(eventsViewModel.events) { event in
                    NavigationLink(
                        destination: EventDetail(event: event, eventsViewModel: eventsViewModel),
                        label: {
                            EventRow(eventsViewModel: eventsViewModel, event: event)
                        }
                    )
                }
            }
            .navigationBarItems(leading:
                HStack {
                    Text("Events")
                        .font(.system(size: 32))
                        .bold()
                    Spacer()
                },
                trailing: NavigationLink(destination: AddEventView(eventsViewModel: eventsViewModel)) {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .font(.system(size: 28))
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
    @State private var selectedIcon: String = "star"

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Create Event")) {
                TextField("Event Name", text: $eventName)
                ColorPicker("Event Color", selection: $selectedColor)
                DatePicker("Event Date", selection: $eventDate, displayedComponents: .date)
                Picker("Event Icon", selection: $selectedIcon) {
                    ForEach(eventsViewModel.availableIcons, id: \.self) { icon in
                        Image(systemName: icon)
                            .tag(icon)
                    }
                }
            }

            Section {
                Button("Add Event") {
                    let newEvent = Event(name: eventName, color: selectedColor, date: eventDate, selectedIcon: selectedIcon)
                    eventsViewModel.events.append(newEvent)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationBarTitle("Add Event")
    }
}

struct EventRow: View {
    @ObservedObject var eventsViewModel: EventsViewModel
    var event: Event

    var body: some View {
        HStack {
            Image(systemName: event.selectedIcon)
                .foregroundColor(.black)
                .font(.system(size: 18))
            Text(event.name)
                .font(.system(size: 20))
            Spacer()
            VStack {
                Text("\(daysRemaining(for: event.date))")
                    .foregroundColor(.gray)
                    .font(.system(size: 18))
                Text("Days remaining")
                    .foregroundColor(.gray)
            }
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
    @State private var editedIcon: String

    @State private var isEditing = false

    var event: Event
    var eventsViewModel: EventsViewModel

    init(event: Event, eventsViewModel: EventsViewModel) {
        self.event = event
        self.eventsViewModel = eventsViewModel
        _editedEventName = State(initialValue: event.name)
        _editedColor = State(initialValue: event.color)
        _editedDate = State(initialValue: event.date)
        _editedIcon = State(initialValue: event.selectedIcon)
    }

    var body: some View {
        VStack {
            if isEditing {
                Form {
                    Section(header: Text("Update Event")) {
                        TextField("Event Name", text: $editedEventName)
                            .font(.largeTitle)
                            .padding()
                        ColorPicker("Event Color", selection: $editedColor)
                        DatePicker("Event Date", selection: $editedDate, displayedComponents: .date)
                        Picker("Event Icon", selection: $editedIcon) {
                            ForEach(eventsViewModel.availableIcons, id: \.self) { icon in
                                Image(systemName: icon)
                                    .tag(icon)
                            }
                        }
                    }
                }
            } else {
                List {
                    Section(header: Text("Event Detail")) {
                        Text(editedEventName)
                            .font(.largeTitle)
                            .padding()
                        Text("Date : \(formattedDate(for: editedDate))")
                            .foregroundColor(.gray)
                    }
                }
            }

            Spacer()

            if !isEditing {
                Button("Edit") {
                    isEditing.toggle()
                }
            } else {
                Button("Save") {
                    let editedEvent = Event(id: event.id, name: editedEventName, color: editedColor, date: editedDate, selectedIcon: editedIcon)
                    eventsViewModel.updateEvent(event: editedEvent)
                    isEditing.toggle()
                }
            }
        }
        .navigationBarTitle(Text(editedEventName), displayMode: .inline)
    }

    private func formattedDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

