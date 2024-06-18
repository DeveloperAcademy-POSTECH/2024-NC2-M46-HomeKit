import SwiftUI

struct FakeHome: Identifiable {
    let id = UUID()
    var name: String
    var rooms: [FakeRoom]
}

struct FakeRoom: Identifiable {
    let id = UUID()
    var name: String
    var accessories: [FakeAccessory]
}

struct FakeAccessory: Identifiable {
    let id = UUID()
    var name: String
}
