//
//  MainView.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 10/17/20.
//

import SwiftUI
import LocalizationHelperKit

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
    @State private var isChoosingCodeToLocalize = false
    @State private var languageCodes = [ISOLanguageCode]()

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

        return Group {
            if viewModel.project != nil {
                Text(viewModel.projectName ?? "")
                Divider()
                
                if viewModel.localizationFiles.count == 0 {
                    Spacer()
                    if isChoosingCodeToLocalize {
                        Text("Choose languages:")
                        List{
                            ForEach(0..<languageCodes.count){ index in
                                HStack {
                                    Button(action: {
                                        languageCodes[index].isSelected.toggle()
                                    }, label: {
                                        HStack {
                                            if languageCodes[index].isSelected {
                                                Text("✓")
                                                    .animation(.easeIn)
                                            } else {
                                                Text(" ")
                                                    .animation(.easeOut)
                                            }
                                            Text("[\(languageCodes[index].code)] " + languageCodes[index].name)
                                        }
                                    })
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                            }
                        }
                            .frame(width: 300)
                    } else {
                        Text("This project has not been localized yet.\nDo you want to localize it?")
                            .multilineTextAlignment(.center)
                    }
                    
                    Button("Localize") {
                        if !isChoosingCodeToLocalize {
                            isChoosingCodeToLocalize = true
                            languageCodes = ISOLanguageCode.all
                        }
                        else {
                            try? viewModel.addLocalizationIfNotExists(code: "en")
                            languageCodes.filter({$0.isSelected}).forEach {
                                try? viewModel.addLocalizationIfNotExists(code: $0.code)
                            }
                            
                            try? viewModel.openLocalizableFiles()
                        }
                    }
                    .disabled(isChoosingCodeToLocalize && languageCodes.filter({$0.isSelected}).isEmpty)
                    Spacer()
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.localizationFiles) { file in
                                VStack {
                                    Text(ISOLanguageCode.all.first(where: {file.languageCode == $0.code})?.name ?? file.languageCode)
                                    ForEach(file.filteredContent(query: query)) { text in
                                        VStack(alignment: .leading) {
                                            Text(text.key)
                                                .lineLimit(0)
                                                .multilineTextAlignment(.leading)
                                            Text(text.value)
                                                .lineLimit(0)
                                                .multilineTextAlignment(.leading)
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                        .padding(.bottom, 8)
                                    }
                                    Spacer()
                                    TextField(file.languageCode, text: bindingForTextField(file: file))
                                        .frame(width: colWidth)
                                }
                                .frame(width: colWidth)
                                Divider()
                            }
                        }
                        .padding(.bottom, 16)
                    }
                }
                
                Divider()
                
                HStack {
                    Toggle(isOn: $isSwiftgenEnabled.didSet(execute: { state in
                        UserDefaults.standard.set(state, forKey: "Settings.isSwiftgenEnabled")
                    })) {
                        Text("Swiftgen")
                    }
                    Spacer()
                }
                
                Divider()
                if !isSwiftgenEnabled {
                    HStack {
                        Text("Pattern")
                        TextField("pattern for copying", text: patternBinding())
                        Text("Ex: \(exampleText)")
                    }
                    Divider()
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
                    }
                        .disabled(!canAdd)
                    
                    Spacer()
                }
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.viewModel.error = nil
                            }
                        }
                    Divider()
                }
                HStack {
                    Text("Author: Chung Tran (bigearsenal)")
                    Link(url: "https://www.linkedin.com/in/chung-tr%E1%BA%A7n-39b46569/", description: "LinkedIn")
                    Link(url: "https://github.com/bigearsenal/XCodeLocalizationHelper", description: "Repository")
                    Spacer()
                    Link(url: "https://www.buymeacoffee.com/bigearsenal", description: "☕ Buy me a coffee")
                    Spacer()
                    
                    openProjectButton(title: "Open another...")
                    Button("Quit") {
                        NSApplication.shared.terminate(self)
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
    
    private func bindingForTextField(file: LocalizableFile) -> Binding<String>
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
            (NSApplication.shared.delegate as! AppDelegate).statusBar?.hidePopover()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
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
                    (NSApplication.shared.delegate as! AppDelegate).statusBar?.showPopover()
                } else {
                    // User clicked on "Cancel"
                    return
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
