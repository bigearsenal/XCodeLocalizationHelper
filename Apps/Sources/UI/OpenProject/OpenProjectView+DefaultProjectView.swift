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
        @State private var project: (XcodeProj, PathKit.Path)?
        @State private var targetName = ""
        @State private var isShowingAlert = false
        @State private var error: Error?
        
        var body: some View {
            VStack {
                content
                
                if project != nil, !targetName.isEmpty {
                    Button("Open") {
                        
                    }
                }
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
        .padding()
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

#if DEBUG
struct OpenDefaultProjectView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OpenProjectView.DefaultProjectView()
                .nilProjectView
            
            OpenProjectView.DefaultProjectView()
                .projectView(project: (XcodeProj.demoProject.0!, XcodeProj.demoProject.1))
        }
    }
}
#endif
