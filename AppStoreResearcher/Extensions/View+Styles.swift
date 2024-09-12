//
//  View+Styles.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/12/24.
//

import SwiftUI

struct RoundedBG: ViewModifier {
    var fill: Color
    var cornerRadius: CGFloat = 6
    
    init(fill: Color, cornerRadius: CGFloat?) {
        self.fill = fill
        if cornerRadius != nil {
            self.cornerRadius = cornerRadius!
        }
    }
    
    func body(content: Content) -> some View {
        content
            .background(RoundedRectangle(cornerRadius: cornerRadius).fill(fill))
    }
}

struct PillButton: ViewModifier {
    var bgColor: Color?
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(minWidth: 260)
            .background(bgColor ?? Color.accentColor)
            .clipShape(Capsule())
            .fontWeight(.semibold)
    }
}

struct PillButtonMini: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 6)
            .padding(.horizontal, 22)
            .background(Color.accentColor)
            .clipShape(Capsule())
            .fontWeight(.semibold)
    }
}

// Keeping this around in case we need
struct UseAppFont: ViewModifier {
    var size: CGFloat
    var relativeTo: Font.TextStyle
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("SFCompactRounded-Bold", size: size, relativeTo: relativeTo))
    }
}

extension View {
    public func roundedBG (fill: Color) -> some View {
        modifier(RoundedBG(fill: fill, cornerRadius: nil))
    }
    
    public func roundedBG (fill: Color, cornerRadius: CGFloat) -> some View {
        modifier(RoundedBG(fill: fill, cornerRadius: cornerRadius))
    }
    
    public func pillButton(bgColor: Color? = nil) -> some View {
        modifier(PillButton(bgColor: bgColor))
    }
    
    public func pillButtonMini() -> some View {
        modifier(PillButtonMini())
    }
    
    public func useAppFont(size: CGFloat, relativeTo: Font.TextStyle) -> some View {
        modifier(UseAppFont(size: size, relativeTo: relativeTo))
    }
}
