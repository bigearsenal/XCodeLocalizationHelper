//
//  ContentView.swift
//  LocalizationHelperDemo
//
//  Created by Chung Tran on 28/06/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("hello")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, .init(identifier: "es"))
    }
}
