//
//  OpenDefaultProjectView.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 24/07/2021.
//

import SwiftUI
import XcodeProj
import PathKit

extension OpenProjectView {
    struct DefaultProjectView: View {
        @Injected fileprivate var filePickerService: FilePickerServiceType
        let handler: OpenProjectHandler
        
        @State private var project: (XcodeProj, PathKit.Path)?
        @State private var targetName = ""
        @State private var isShowingAlert = false
        @State private var error: Error?
        
        var body: some View {
            VStack {
                content
                
                Button("Open") {
                    do {
                        guard let project = project else {return}
                        UserDefaults.standard.set("Pods/swiftgen/bin/swiftgen config run --config swiftgen.yml", forKey: "automationCommand")
                        try handler.openDefaultProject(xcodeproj: project.0, targetName: targetName, path: project.1)
                    } catch {
                        self.error = error
                        self.isShowingAlert.toggle()
                    }
                }
                .disabled(project == nil || targetName.isEmpty)
            }
            .alert(isPresented: $isShowingAlert, content: {
                Alert(title: Text("Error"), message: Text("Could not open project. Error: \(self.error?.localizedDescription ?? "")"))
            })
        }
        
        var content: some View {
            Group {
                if let project = project {
                    projectView(project: project)
                } else {
                    nilProjectView
                }
            }
            
        }
    }
}

// MARK: - Subviews
private extension OpenProjectView.DefaultProjectView {
    func projectView(project: (XcodeProj, PathKit.Path)) -> some View {
        VStack {
            HStack {
                Text("Directory")
                Spacer()
                Text(project.1.string)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .lineLimit(1)
                Image(systemName: "xmark.circle.fill")
                    .onTapGesture {
                        self.project = nil
                    }
            }
            
            HStack {
                Text("Target")
                Spacer()
                Picker("", selection: $targetName, content: {
                    
                    Text("Please select one target")
                        .foregroundColor(.secondary)
                        .tag("")
                    ForEach(
                        project.0.pbxproj.nativeTargets
                            .filter {!$0.name.hasSuffix("Tests")},
                        id: \.name)
                    { target in
                        Text(target.name).tag(target.name)
                    }
                })
                .frame(width: 200)
            }
        }
    }
    
    var nilProjectView: some View {
        Button("Open a .xcodeproj file") {
            showFilePicker()
        }
    }
}

// MARK: - Actions
extension OpenProjectView.DefaultProjectView {
    private func showFilePicker() {
        filePickerService.showFilePicker(
            title: "Choose a .xcodeproj file",
            showsResizeIndicator: true,
            showsHiddenFiles: false,
            allowsMultipleSelection: false,
            canChooseDirectories: false,
            canChooseFiles: true,
            allowedFileTypes: ["xcodeproj"],
            directoryURL: nil
        ) { pathString in
            let path = PathKit.Path(pathString)
            do {
                project = (try XcodeProj(path: path), path)
            } catch {
                self.error = error
            }
        }
    }
}

#if DEBUG
struct OpenDefaultProjectView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OpenProjectView.DefaultProjectView(handler: OpenProjectHandler_Preview())
                .nilProjectView
            
            OpenProjectView.DefaultProjectView(handler: OpenProjectHandler_Preview())
                .projectView(project: (XcodeProj.demoProject.0!, XcodeProj.demoProject.1))
        }
    }
}
#endif
