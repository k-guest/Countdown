import SwiftUI
import Foundation

struct Event: Identifiable {
    var id = UUID()
    var name: String
    var color: Color
    var date: Date
    var selectedIconURL: URL
}
