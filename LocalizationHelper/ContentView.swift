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
    @State private var error: Error?
    @State private var pattern = UserDefaults.standard.string(forKey: "Settings.pattern") ?? "NSLocalizedString(\"<key>\", comment: \"\")" {
        didSet { UserDefaults.standard.set(pattern, forKey: "Settings.pattern") }
    }
    
    init() {
        defer {openProject()}
    }

    var body: some View {
        let binding = Binding<String>(
            get: { self.enteringKey },
            set: {
                self.enteringKey = $0
                self.viewModel.query = $0
                var newFiles = viewModel.localizationFiles
                for i in 0..<newFiles.count {
                    newFiles[i].newValue = ""
                }
                viewModel.localizationFiles = newFiles
            }
        )
        
        let filteredContentOfFile: (LocalizationFile) -> [LocalizationFile.Content] = { file in
            if viewModel.query == nil {return Array(file.content.prefix(10))}
            return Array(file.content.filter {$0.key.lowercased().contains(viewModel.query!.lowercased()) ||
                $0.value.lowercased().contains(viewModel.query!.lowercased())
            }.prefix(10))
        }
        
        var isNewKey = true
        if !enteringKey.isEmpty {
            for file in viewModel.localizationFiles {
                if file.keys.contains(enteringKey) {isNewKey = false; break}
            }
        } else {
            isNewKey = false
        }
        
        var canAdd = isNewKey
        if canAdd {
            for file in viewModel.localizationFiles {
                if file.newValue.isEmpty {canAdd = false; break}
            }
        }
        
        let exampleText = pattern.replacingOccurrences(of: "<key>", with: enteringKey)
        
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
                                    VStack(alignment: .leading) {
                                        Text(text.key)
                                            .lineLimit(0)
                                            .multilineTextAlignment(.leading)
                                        Text(text.value)
                                            .lineLimit(0)
                                            .multilineTextAlignment(.leading)
                                    }
                                    
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
                        .disabled(!isNewKey)
                    Button("Add") {
                        for var file in viewModel.localizationFiles {
                            let textToWrite = "\"\(enteringKey)\" = \"\(file.newValue)\";\n"
                            guard let data = textToWrite.data(using: .utf8) else {return}
                            do {
                                let fileHandler = try FileHandle(forWritingTo: URL(fileURLWithPath: file.url))
                                try fileHandler.seekToEnd()
                                fileHandler.write(data)
                                try fileHandler.close()
                                
                                file.content.append(LocalizationFile.Content(key: enteringKey, value: file.newValue))
                                file.newValue = ""
                                var files = viewModel.localizationFiles
                                if let index = files.firstIndex(where: {$0.id == file.id}) {
                                    files[index] = file
                                    viewModel.localizationFiles = files
                                }
                            } catch {
                                self.error = error
                                return
                            }
                        }
                        self.enteringKey = ""
                    }
                        .disabled(!canAdd)
                    Spacer()
                }
                HStack {
                    Text("Pattern")
                    TextField("pattern for copying", text: $pattern)
                    Text("Ex: \(exampleText)")
                }
                if let error = error {
                    Text(error.localizedDescription)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.error = nil
                            }
                        }
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
