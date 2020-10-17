//
//  ContentView.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 10/17/20.
//

import SwiftUI

struct ContentView: View {
    let colWidth: CGFloat = 300
    @State private var currentProjectUrl = UserDefaults.standard.string(forKey: "Settings.currentProjectUrl") {
        didSet { UserDefaults.standard.set(currentProjectUrl, forKey: "Settings.currentProjectUrl") }
    }
    @ObservedObject var viewModel = ViewModel()
    @State private var enteringKey = ""
    
    init() {
        defer {openProject()}
    }

    var body: some View {
        Group {
            if let url = currentProjectUrl {
                HStack {
                    Text("Current project: " + url)
                    openProjectButton(title: "Other...")
                }
                Spacer()
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.localizationFiles) { file in
                            List(0..<file.content.count) { index in
                                Text(file.content[index])
                            }
                            .frame(width: colWidth)
                        }
                    }
                }
                Spacer()
                TextField("Enter key...", text: $enteringKey)
                    .frame(width: colWidth)
                Spacer()
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0..<viewModel.localizationFiles.count) { index in
                            TextField("", text: $viewModel.localizationFiles[index].newValue)
                                .frame(width: colWidth)
                        }
                    }
                }
                Button("Add") {
                    
                }
            } else {
                openProjectButton()
            }
        }
        .padding(8)
        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
    }
    
    fileprivate func openProjectButton(title: String = "Open XCode project") -> Button<Text> {
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
                    openProject()
                }
                
            } else {
                // User clicked on "Cancel"
                return
            }
        }
    }
    
    fileprivate func openProject() {
        guard let path = currentProjectUrl else {return}
        viewModel.openProject(path: path)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
