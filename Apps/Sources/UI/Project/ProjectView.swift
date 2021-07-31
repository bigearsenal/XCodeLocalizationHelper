//
//  ProjectView.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 25/07/2021.
//

import SwiftUI
#if DEBUG
import XcodeProj
#endif

private let defaultCopyPattern = "NSLocalizedString(\"<key>\", comment: \"\")"

struct ProjectView: View {
    // MARK: - AppStorage
    @AppStorage("isAutomationEnabled") var isAutomationEnabled = false
    @AppStorage("isCopyingToClipboardEnabled") var isCopyingToClipboardEnabled = true
    @AppStorage("automationCommand") var automationCommand: String?
    @AppStorage("copyPattern") var copyPattern = defaultCopyPattern
    
    // MARK: - State
    @ObservedObject var viewModel: ProjectViewModel
    @State var isLocalizingProject = false
    @State var query: String = ""
    
    var body: some View {
        ZStack {
            if viewModel.localizableFiles.isEmpty {
                emptyView
            } else {
                VStack {
                    localizableFilesList
                    Divider()
                    actionViews
                    Divider()
                    patternView
                    Divider()
                    if viewModel.error != nil {
                        errorView
                    }
                }
            }
        }
        .onAppear(perform: {
            viewModel.refresh()
        })
        .sheet(isPresented: $isLocalizingProject, content: {
            selectLanaguagesView
        })
    }
    
    fileprivate var emptyView: some View {
        Button("Localize project") {
            isLocalizingProject.toggle()
        }
    }
    
    fileprivate var localizableFilesList: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(viewModel.localizableFiles, id: \.id) { file in
                    LocalizableFileView(file: file, query: $query, newValue: newValueBinding(file: file))
                    Color(red: 208/255, green: 207/255, blue: 209/255)
                        .frame(width: 1)
                }
                
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .onTapGesture {
                        isLocalizingProject.toggle()
                    }
                    .padding([.leading, .trailing])
            }
            .padding([.leading, .trailing])
        }
    }
    
    fileprivate var actionViews: some View {
        HStack {
            TextField("Enter key...", text: $query.didSet({ _ in
                viewModel.clearTextFields()
            }))
                .frame(width: 300)
            Button("Translate") {
                viewModel.translate(query: query)
            }
                .disabled(!isNewKey())
            
            Button("Add this key") {
                viewModel.addNewPhrase(key: query)
                if isAutomationEnabled {
                    viewModel.runAutomation(command: automationCommand)
                }
                
                if isCopyingToClipboardEnabled {
                    viewModel.copyToClipboard(
                        text: (copyPattern.isEmpty ? defaultCopyPattern: copyPattern)
                            .replacingOccurrences(of: "<key>", with: query)
                    )
                }
            }
                .disabled(!canAdd())
            
            Spacer()
        }
        .padding([.leading, .trailing])
    }
    
    fileprivate var patternView: some View {
        HStack {
            Toggle(isOn: $isCopyingToClipboardEnabled) {
                Text("Copy to clipboard with custom pattern: ")
            }
            TextField(defaultCopyPattern, text: $copyPattern)
        }
        .padding([.leading, .trailing])
    }
    
    fileprivate var errorView: some View {
        Text(viewModel.error ?? "")
            .foregroundColor(.red)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.viewModel.error = nil
                }
            }
    }
    
    fileprivate var selectLanaguagesView: some View {
        SelectLanguageView(
            languages: ISOLanguageCode.all
                .filter {code in
                    !viewModel.localizableFiles.contains(where: {$0.languageCode == code.code})
                },
            isShowing: $isLocalizingProject,
            canSelectMultipleLanguages: true
        ) { languages in
            self.viewModel.languagesDidSelect(languages)
        }
            .frame(width: 400, height: 400, alignment: .center)
    }
    
    // MARK: - Binding
    private func newValueBinding(file: LocalizableFile) -> Binding<String>
    {
        Binding<String>(
            get: {
                file.newValue
            },
            set: {
                var file = file
                file.newValue = $0
                var files = viewModel.localizableFiles
                guard let index = files.firstIndex(where: {$0.id == file.id}) else {return}
                files[index] = file
                viewModel.localizableFiles = files
            }
        )
    }
    
    // MARK: - Helpers
    private func isNewKey() -> Bool {
        if !query.isEmpty {
            for file in viewModel.localizableFiles {
                if file.content.map({$0.key}).contains(query) {return false}
            }
        } else {
            return false
        }
        return true
    }
    
    private func canAdd() -> Bool {
        guard isNewKey() else {return false}
        for file in viewModel.localizableFiles {
            if file.newValue.isEmpty {return false}
        }
        return true
    }
}

#if DEBUG
struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(viewModel: .init(project: .default(.demo)))
            .emptyView
        
        ProjectView(viewModel: .init(project: .default(.demo)))
            .localizableFilesList
        
        ProjectView(viewModel: .init(project: .default(.demo)))
            .actionViews
    }
}
#endif
