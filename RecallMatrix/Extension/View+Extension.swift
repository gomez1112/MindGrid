//
//  View+Extension.swift
//  RecallMatrix
//
//  Created by Gerard Gomez on 12/8/24.
//

import SwiftUI

enum Platform {
    case iOS, macOS, visionOS
}

extension View {
    /// Applies platform-specific modifications to the view.
    /// - Parameters:
    ///   - platform: The platform to apply the modifications for.
    ///   - content: A closure that takes the view and returns a modified view.
    @ViewBuilder
    func platform<Content: View>(for platform: Platform, @ViewBuilder content: (Self) -> Content) -> some View {
        switch platform {
            case .iOS:
                #if os(iOS)
                content(self)
                #else
                self
                #endif
                
            case .macOS:
                #if os(macOS)
                content(self)
                #else
                self
                #endif
                
            case .visionOS:
                #if os(visionOS)
                content(self)
                #else
                self
                #endif
        }
    }
    /// Applies modifications to the view for all platforms except the specified one.
    /// - Parameters:
    ///   - platform: The platform to exclude from the modifications.
    ///   - content: A closure that takes the view and returns a modified view.
    ///
    @ViewBuilder
    func platformNot<Content: View>(for platform: Platform, @ViewBuilder content: (Self) -> Content) -> some View {
        switch platform {
            case .iOS:
                #if !os(iOS)
                content(self)
                #else
                self
                #endif
                
            case .macOS:
                #if !os(macOS)
                content(self)
                #else
                self
                #endif
                
            case .visionOS:
                #if !os(visionOS)
                content(self)
                #else
                self
                #endif
        }
    }
    
    var isVision: Bool {
        #if os(visionOS)
        true
        #else
        false
        #endif
    }
    /// Returns a value based on the current platform.
    /// - Parameters:
    ///   - iOS: The value for iOS.
    ///   - macOS: The value for macOS.
    ///   - tvOS: The value for tvOS.
    ///   - visionOS: The value for visionOS.
    /// - Returns: The value corresponding to the current platform.
    func valueFor<V>(iOS: V, macOS: V, visionOS: V) -> V {
        #if os(visionOS)
        visionOS
        #elseif os(macOS)
        macOS
        #else
        iOS
        #endif
    }
}
