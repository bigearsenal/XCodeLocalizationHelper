//
//  PreferenceKeys.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 02/08/2021.
//

import Foundation
import SwiftUI

struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
