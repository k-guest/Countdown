import SwiftUI
import Foundation

struct Event: Identifiable {
    var id = UUID()
    var name: String
    var date: Date
    var color: Color
    var selectedIconURL: URL
}
