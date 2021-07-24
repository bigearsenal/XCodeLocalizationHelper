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
        @State fileprivate var project: (XcodeProj, PathKit.Path)?
        @State fileprivate var targetName = ""
        @State fileprivate var isShowingAlert = false
        @State fileprivate var error: Error?
        
        #if DEBUG
        init(project: (XcodeProj, PathKit.Path)?) {
            self.project = project
        }
        #endif
        
        var body: some View {
            VStack {
                form
                
                if project != nil, !targetName.isEmpty {
                    Button("Open") {
                        
                    }
                }
            }
            .alert(isPresented: $isShowingAlert, content: {
                Alert(title: Text("Error"), message: Text("Could not open project. Error: \(self.error?.localizedDescription ?? "")"))
            })
            
        }
        
        var form: some View {
            Form {
                Section {
                    if let project = project {
                        Text(project.1.string)
                            .lineLimit(1)
                            .truncationMode(.middle)
                            .lineLimit(1)
                        
                        Picker(selection: $targetName, label: Text("Target"), content: {
                            
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
                    } else {
                        Button("Open a .xcodeproj file") {
                            showFilePicker()
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Actions
extension OpenProjectView.DefaultProjectView {
    private func showFilePicker() {
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

                if let pathString = result?.path {
                    let path = PathKit.Path(pathString)
                    do {
                        project = (try XcodeProj(path: path), path)
                    } catch {
                        self.error = error
                    }
                    
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    (NSApplication.shared.delegate as! AppDelegate).statusBar?.showPopover()
                }
            } else {
                // User clicked on "Cancel"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    (NSApplication.shared.delegate as! AppDelegate).statusBar?.showPopover()
                }
            }
        }
    }
}


struct OpenDefaultProjectView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OpenProjectView.DefaultProjectView(project: (XcodeProj.demoProject.0!, XcodeProj.demoProject.1))
        }
    }
}
