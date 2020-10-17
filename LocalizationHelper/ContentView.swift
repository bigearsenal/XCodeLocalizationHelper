//
//  ContentView.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 10/17/20.
//

import SwiftUI

struct ContentView: View {
    @State private var currentProjectUrl: String? = UserDefaults.standard.string(forKey: "Settings.currentProjectUrl") {
        didSet { UserDefaults.standard.set(currentProjectUrl, forKey: "Settings.currentProjectUrl") }
    }

    var body: some View {
        Group {
            if let url = currentProjectUrl {
                HStack {
                    Text("Current project: " + url)
                    openProject(title: "Other...")
                }
                
                Spacer()
                Text("Hello, World!")
                Spacer()
            } else {
                openProject()
            }
        }
        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
    }
    
    fileprivate func openProject(title: String = "Open XCode project") -> Button<Text> {
        return Button(title) {
            let dialog = NSOpenPanel();
            
            dialog.title                   = "Choose an xCode project's directory"
            dialog.showsResizeIndicator    = true
            dialog.showsHiddenFiles        = false
            dialog.allowsMultipleSelection = false
            dialog.canChooseDirectories    = true
            dialog.canChooseFiles          = false
            
            if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
                let result = dialog.url // Pathname of the file
                
                if let path = result?.path {
                    self.currentProjectUrl = path
                }
                
            } else {
                // User clicked on "Cancel"
                return
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
