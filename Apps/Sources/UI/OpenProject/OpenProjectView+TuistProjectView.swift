//
//  OpenProjectView+TuistProjectView.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 25/07/2021.
//

import SwiftUI
import PathKit

extension OpenProjectView {
    struct TuistProjectView: View {
        let handler: OpenProjectHandler
        @Injected fileprivate var filePickerService: FilePickerServiceType
        @State private var path: PathKit.Path?
        @State private var resourcePath: PathKit.Path?
        @State private var projectName = ""
        @State private var isShowingAlert = false
        @State private var error: Error?
        
        var body: some View {
            Group {
                if let path = path {
                    pathSelectedView(path: path)
                } else {
                    emptyView
                }
            }
            .alert(isPresented: $isShowingAlert, content: {
                Alert(title: Text("Error"), message: Text("Could not open project. Error: \(self.error?.localizedDescription ?? "")"))
            })
        }
        
        func pathSelectedView(path: PathKit.Path) -> some View {
            VStack {
                HStack {
                    Text("Root folder")
                    Spacer()
                    Text(path.string)
                        .frame(maxWidth: 400, alignment: .trailing)
                        .lineLimit(1)
                        .truncationMode(.middle)
                    Image(systemName: "xmark.circle.fill")
                        .onTapGesture {
                            self.path = nil
                            self.resourcePath = nil
                            self.projectName = ""
                        }
                }
                
                HStack {
                    Text("Project name")
                    Spacer()
                    TextField("Please enter the project's name", text: $projectName)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 400)
                    Image(systemName: "xmark.circle.fill")
                        .onTapGesture {
                            self.projectName = ""
                        }
                }
                
                HStack {
                    Text("Resources folder")
                    Spacer()
                    
                    if let resourcePath = resourcePath {
                        Text(resourcePath.string.replacingOccurrences(of: path.string, with: "."))
                            .frame(maxWidth: 400, alignment: .trailing)
                            .lineLimit(1)
                            .truncationMode(.middle)
                        
                        Image(systemName: "xmark.circle.fill")
                            .onTapGesture {
                                self.resourcePath = nil
                            }
                    } else {
                        Button("Select \"Resouces\" folder") {
                            openFilePickerForSelectingResourceFolder()
                        }
                    }
                }
                
                Button("Open") {
                    openProject()
                }
                .disabled(resourcePath == nil || projectName.isEmpty)
            }
        }
        
        var emptyView: some View {
            Button("Choose project's root folder") {
                openFilePickerForSelectingProjectRootFolder()
            }
        }
        
        // MARK: - Actions
        private func openFilePickerForSelectingProjectRootFolder() {
            filePickerService.showFilePicker(
                title: "Choose your project's root folder",
                showsResizeIndicator: true,
                showsHiddenFiles: false,
                allowsMultipleSelection: false,
                canChooseDirectories: true,
                canChooseFiles: false,
                allowedFileTypes: [],
                directoryURL: nil
            ) { path in
                self.path = .init(path)
                self.projectName = self.path?.lastComponent ?? ""
            }
        }
        
        private func openFilePickerForSelectingResourceFolder() {
            guard let path = path else {return}
            filePickerService.showFilePicker(
                title: "Choose your project's root folder",
                showsResizeIndicator: true,
                showsHiddenFiles: false,
                allowsMultipleSelection: false,
                canChooseDirectories: true,
                canChooseFiles: false,
                allowedFileTypes: [],
                directoryURL: path.string
            ) { resourcePath in
                guard let projectPath = self.path?.string,
                      resourcePath.contains(projectPath)
                else {
                    self.error = LocalizationHelperError.resourcePathMustBeInsideProjectPath
                    self.isShowingAlert.toggle()
                    return
                }
                
                self.resourcePath = .init(resourcePath)
            }
        }
        
        private func openProject() {
            guard let path = path,
                  let resourcePath = resourcePath,
                  !projectName.isEmpty
            else {return}
            do {
                try handler.openProject(.tuist(.init(path: path, resourcePath: resourcePath, projectName: projectName)))
            } catch {
                self.error = error
                self.isShowingAlert.toggle()
            }
        }
    }
}

#if DEBUG
struct OpenProjectView_TuistProjectView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OpenProjectView.TuistProjectView(handler: OpenProjectHandler_Preview())
                .emptyView
            
            OpenProjectView.TuistProjectView(handler: OpenProjectHandler_Preview())
                .pathSelectedView(path: .init("/Test/Path"))
        }
        
    }
}
#endif
