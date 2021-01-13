//
//  MainView.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 10/17/20.
//

import SwiftUI

struct MainView: View {
    // MARK: - Constants
    let colWidth: CGFloat = 300
    
    // MARK: - Subject
    @ObservedObject var viewModel = MainVM()
    
    // MARK: - State
    @State private var showingAlert = false
    @State private var query = ""
    @State private var isSwiftgenEnabled = UserDefaults.standard.bool(forKey: "Settings.isSwiftgenEnabled")
    @State private var pattern = UserDefaults.standard.string(forKey: "Settings.pattern") ?? "NSLocalizedString(\"<key>\", comment: \"\")"
    @State private var isEnteringKey = false

    // MARK: - Methods
    var body: some View {
        var isNewKey = true
        if !query.isEmpty {
            for file in viewModel.localizationFiles {
                if file.content.map({$0.key}).contains(query) {isNewKey = false; break}
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

        let exampleText = pattern.replacingOccurrences(of: "<key>", with: query)
        
        var title = "LocalizationHelper"
        if let projectName = viewModel.projectName {
            title = projectName
        }
        setTitle(title: title)

        return Group {
            if viewModel.project != nil {
                openProjectButton(title: "Open another...")
                Spacer()
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.localizationFiles) { file in
                            VStack {
                                Text(file.languageCode)
                                List(file.filteredContent(query: query)) { text in
                                    VStack(alignment: .leading) {
                                        Text(text.key)
                                            .lineLimit(0)
                                            .multilineTextAlignment(.leading)
                                        Text(text.value)
                                            .lineLimit(0)
                                            .multilineTextAlignment(.leading)
                                    }

                                }
                                TextField(file.languageCode, text: bindingForTextField(file: file))
                                    .frame(width: colWidth)
                            }
                            .frame(width: colWidth)
                        }
                    }
                    .padding(.bottom, 16)
                }
                Spacer()
                HStack {
                    Toggle(isOn: $isSwiftgenEnabled.didSet(execute: { state in
                        UserDefaults.standard.set(state, forKey: "Settings.isSwiftgenEnabled")
                    })) {
                        Text("Swiftgen")
                    }
                    Spacer()
                }
                Spacer()
                if !isSwiftgenEnabled {
                    HStack {
                        Text("Pattern")
                        TextField("pattern for copying", text: patternBinding())
                        Text("Ex: \(exampleText)")
                    }
                    Spacer()
                }
                HStack {
                    TextField("Enter key...", text: binding()) { self.isEnteringKey = $0
                    }
                        .frame(width: colWidth)
                    Button("Translate") {
                        viewModel.translate()
                    }
                        .disabled(!isNewKey)
                    
                    Button("Add and \(isSwiftgenEnabled ? "run swiftgen": "copy to clipboard")") {
                        viewModel.addNewPhrase()
                        if isSwiftgenEnabled {
                            print(self.viewModel.runSwiftgen())
                        } else {
                            let pasteboard = NSPasteboard.general
                            pasteboard.clearContents()
                            pasteboard.setString(exampleText, forType: .string)
                        }
                        self.query = ""
                    }
                        .disabled(!canAdd)
                    
                    if let error = viewModel.error {
                        Text(error.localizedDescription)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.viewModel.error = nil
                                }
                            }
                    }
                }
            } else {
                openProjectButton()
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Invalid file name"), message: Text("Must choose a Localizable.strings file"))
        }
        .padding(8)
        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
    }
    
    private func binding() -> Binding<String> {
        Binding<String>(
            get: { self.query },
            set: {
                self.query = $0
                self.viewModel.query = $0
                var newFiles = viewModel.localizationFiles
                for i in 0..<newFiles.count {
                    newFiles[i].newValue = ""
                }
                viewModel.localizationFiles = newFiles
            }
        )
    }
    
    private func patternBinding() -> Binding<String> {
        Binding<String>(
            get: { self.pattern },
            set: {
                self.pattern = $0
                UserDefaults.standard.set(pattern, forKey: "Settings.pattern")
            }
        )
    }
    
    private func bindingForTextField(file: LocalizationFile) -> Binding<String>
    {
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
    
    fileprivate func openProjectButton(title: String = "Open a .xcodeproj file") -> Button<Text> {
        return Button(title) {
            let dialog = NSOpenPanel()

            dialog.title                   = "Choose a .xcodeproj file"
            dialog.showsResizeIndicator    = true
            dialog.showsHiddenFiles        = false
            dialog.allowsMultipleSelection = false
            dialog.canChooseDirectories    = false
            dialog.canChooseFiles          = true
            dialog.allowedFileTypes = ["xcodeproj"]

            if (dialog.runModal() ==  .OK) {
                let result = dialog.url // Pathname of the file

                if let path = result?.path {
                    viewModel.openProject(path: path)
                }

            } else {
                // User clicked on "Cancel"
                return
            }
        }
    }
    
//    fileprivate func openProject() {
//        guard let path = projectPath else {return}
//        viewModel.openProject(path: path)
//    }
    
    private func setTitle(title: String) {
        if let ad = NSApplication.shared.delegate as? AppDelegate{
            ad.window.title = title
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
