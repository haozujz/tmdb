//
//  ScrollOffsetPreferenceKey.swift
//  tmdb
//
//  Created by Joseph Zhu on 1/4/2023.
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
