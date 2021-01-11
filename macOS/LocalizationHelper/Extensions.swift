//
//  Extensions.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 27/12/2020.
//

import Foundation
import SwiftUI

extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}
