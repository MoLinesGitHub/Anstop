// LibraryView.swift
import SwiftUI

struct LibraryView: View {
    var body: some View {
        List {
            Section("Artículos") {
                Text("¿Qué es la ansiedad?")
                Text("Técnicas de respiración")
                Text("Mindfulness para principiantes")
            }
            Section("Videos") {
                Text("Relajación guiada")
                Text("Grounding 5-4-3-2-1")
            }
        }
        .navigationTitle("Biblioteca")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { LibraryView() }
}
