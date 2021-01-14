//
//  Link.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 14/01/2021.
//

import SwiftUI

struct Link: View {
    let url: String
    let description: String?
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                NSWorkspace.shared.open(url)
            }
        }) {
            Text(description ?? url).underline()
                .foregroundColor(Color.blue)
        }
            .buttonStyle(PlainButtonStyle())
            .onHover { inside in
                if inside {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
    }
}
