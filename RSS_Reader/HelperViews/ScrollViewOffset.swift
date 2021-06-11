//
//  ScrollViewOffset.swift
//  RSS_Reader
//
//  Created by Kenanja Nuding on 4/15/21.
//

import Foundation
import SwiftUI

/// ScrollView that track the offset and called it in a closure with the value
struct ScrollViewOffset<Content: View>: View {
    let axes: Axis.Set
    let shows_indicators: Bool
    let on_offset_change: (Int) -> Void
    let content: Content

    init(_ axes: Axis.Set = .vertical,
         shows_indicators: Bool = true,
         on_offset_change: @escaping (Int) -> Void,
        @ViewBuilder content: @escaping () -> Content) {
        self.axes = axes
        self.shows_indicators = shows_indicators
        self.on_offset_change = on_offset_change
        self.content = content()
    }
    
    var body: some View {
        ScrollView(axes, showsIndicators: shows_indicators, content: {
            offset_reader
            content
                .padding(.top, -5)
        })
        .coordinateSpace(name: "frameLayer")
        .onPreferenceChange(OffsetPreferenceKey.self) { offset in
            if offset != 0 {
                on_offset_change(offset)
            }
        }
    }
    
    var offset_reader: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: Int(proxy.frame(in: .named("frameLayer")).minY)
                )
        }
        .frame(height: 0)
    }
}

private struct OffsetPreferenceKey: PreferenceKey {
    typealias Value = Int
    static var defaultValue: Int = .zero
    static func reduce(value: inout Int, nextValue: () -> Int) {
        guard value != 0 else { return }
    }
}
