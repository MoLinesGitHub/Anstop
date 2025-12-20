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
}
