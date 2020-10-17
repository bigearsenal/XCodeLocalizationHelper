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
    @State private var isEnteringKey = false
    
    init() {
        defer {openProject()}
    }

    var body: some View {
        let binding = Binding<String>(
            get: { self.enteringKey },
            set: {
                self.enteringKey = $0
                self.viewModel.query = $0
            }
        )
        
        let filteredContentOfFile: (LocalizationFile) -> [LocalizationFile.Content] = { file in
            if viewModel.query == nil {return file.content}
            return file.content.filter {$0.value.lowercased().contains(viewModel.query!.lowercased())}
        }
        
        let bindingForTextFieldOfFile: ((LocalizationFile) -> Binding<String>) = { file in
            Binding<String>(
                get: {
                    file.newValue
                },
                set: {
                    var file = file
                    file.newValue = $0
                    var files = viewModel.localizationFiles
                    guard let index = files.firstIndex(where: {$0.id == file.id}) else {return}
                    files[index] = file
                    viewModel.localizationFiles = files
                }
            )
        }

        return Group {
            if let url = currentProjectUrl {
                HStack {
                    Text("Current project: " + url)
                    openProjectButton(title: "Other...")
                }
                Spacer()
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.localizationFiles) { file in
                            VStack {
                                Text(file.languageCode)
                                List(filteredContentOfFile(file)) { text in
                                    Text(text.value)
                                        .lineLimit(0)
                                        .multilineTextAlignment(.leading)
                                }
                                TextField(file.languageCode, text: bindingForTextFieldOfFile(file))
                                    .frame(width: colWidth)
                            }
                            .frame(width: colWidth)
                        }
                    }
                    .padding(.bottom, 16)
                }
                Spacer()
                HStack {
                    TextField("Enter key...", text: binding) { self.isEnteringKey = $0 }
                        .frame(width: colWidth)
                    Button("Translate") {
                        viewModel.translate()
                    }
                    Button("Add") {
                        
                    }
                    Spacer()
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
