// Animation+App.swift
import SwiftUI

public extension Animation {
    /// Suave y agradable para transiciones de interfaz habituales
    static var gentle: Animation { .easeInOut(duration: 0.25) }
    /// Rápida, ideal para presionar/soltar y micro-interacciones
    static var quick: Animation { .easeInOut(duration: 0.15) }
}
