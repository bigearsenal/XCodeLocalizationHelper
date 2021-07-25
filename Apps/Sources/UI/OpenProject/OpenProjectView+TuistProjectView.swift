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
        @Injected fileprivate var filePickerService: FilePickerServiceType
        @State private var resourcePath: PathKit.Path?
        @State private var projectName = ""
        let handler: OpenProjectHandler
        @State private var isShowingAlert = false
        @State private var error: Error?
        
        var body: some View {
            Group {
                if let resourcePath = resourcePath {
                    pathSelectedView(path: resourcePath)
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
                Text(path.string)
                    .lineLimit(1)
                    .truncationMode(.middle)
                HStack {
                    Text("Project name")
                    Spacer()
                    TextField("Please enter the project's name", text: $projectName)
                }
                Button("Open") {
                    do {
                        try handler.openProject(.tuist(.init(resourcePath: path, projectName: projectName)))
                    } catch {
                        self.error = error
                        self.isShowingAlert.toggle()
                    }
                    
                }
                .disabled(projectName.isEmpty)
            }
        }
        
        var emptyView: some View {
            Button("Choose \"Resource\" folder") {
                openFilePicker()
            }
        }
        
        func openFilePicker() {
            filePickerService.showFilePicker(
                title: "Choose \"Resource\" folder of your project",
                showsResizeIndicator: true,
                showsHiddenFiles: false,
                allowsMultipleSelection: false,
                canChooseDirectories: true,
                canChooseFiles: false,
                allowedFileTypes: [])
            { path in
                self.resourcePath = .init(path)
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
