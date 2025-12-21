// Font+Custom.swift
import SwiftUI

extension Font {
    // PROMETHEUS font para títulos
    static func prometheus(_ size: CGFloat) -> Font {
        .custom("PROMETHEUS", size: size)
    }
    
    // Variantes pre-configuradas de PROMETHEUS
    static var prometheusLargeTitle: Font {
        .custom("PROMETHEUS", size: 40)
    }
    
    static var prometheusTitle: Font {
        .custom("PROMETHEUS", size: 34)
    }
    
    static var prometheusTitle2: Font {
        .custom("PROMETHEUS", size: 28)
    }
    
    static var prometheusTitle3: Font {
        .custom("PROMETHEUS", size: 24)
    }
    
    static var prometheusHeadline: Font {
        .custom("PROMETHEUS", size: 20)
    }
    
    // Futura para texto del cuerpo
    static func futura(_ size: CGFloat) -> Font {
        .custom("Futura-Medium", size: size)
    }
    
    static var futuraBody: Font {
        .custom("Futura-Medium", size: 17)
    }
    
    static var futuraCallout: Font {
        .custom("Futura-Medium", size: 16)
    }
    
    static var futuraSubheadline: Font {
        .custom("Futura-Medium", size: 15)
    }
    
    static var futuraFootnote: Font {
        .custom("Futura-Medium", size: 13)
    }
    
    static var futuraCaption: Font {
        .custom("Futura-Medium", size: 12)
    }
    
    static var futuraCaption2: Font {
        .custom("Futura-Medium", size: 11)
    }
    
    // Títulos
    static var futuraLargeTitle: Font {
        .custom("Futura-Medium", size: 34)
    }
    
    static var futuraTitle: Font {
        .custom("Futura-Medium", size: 28)
    }
    
    static var futuraTitle2: Font {
        .custom("Futura-Medium", size: 22)
    }
    
    static var futuraTitle3: Font {
        .custom("Futura-Medium", size: 20)
    }
    
    static var futuraHeadline: Font {
        .custom("Futura-Medium", size: 17)
    }
    
    // Futura con tamaños custom
    static func futura(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        // Futura-Medium es equivalente a .medium/.semibold
        // Para otros pesos usamos Futura-Medium como base
        .custom("Futura-Medium", size: size)
    }
    
    // Semánticos comunes con Futura
    static var futuraSemibold18: Font {
        .custom("Futura-Medium", size: 18)
    }
    
    static var futuraMedium16: Font {
        .custom("Futura-Medium", size: 16)
    }
    
    static var futuraRegular14: Font {
        .custom("Futura-Medium", size: 14)
    }
    
    static var futuraLarge48: Font {
        .custom("Futura-Medium", size: 48)
    }
}
