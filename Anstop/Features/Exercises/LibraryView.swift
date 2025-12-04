//
//  LibraryView.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import SwiftUI
import GlassKitPro

struct LibraryView: View {
    let protocols = Protocol.all

    var body: some View {
        List {
            Section {
                ForEach(protocols) { item in
                    NavigationLink(destination: ProtocolDetailView(protocolData: item)) {
                        HStack(spacing: 16) {
                            Image(systemName: item.icon)
                                .font(.title2)
                                .foregroundStyle(item.color)
                                .frame(width: 40, height: 40)
                                .background(item.color.opacity(0.1))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                    .font(.headline)

                                Text(item.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            } header: {
                Text("Guías Prácticas")
            } footer: {
                Text("Estos protocolos están diseñados para ayudarte en momentos específicos.")
            }
        }
        .anstopScrollBackground(.library)
        .navigationTitle("Biblioteca")
    }
}

#Preview {
    NavigationStack {
        LibraryView()
    }
}
