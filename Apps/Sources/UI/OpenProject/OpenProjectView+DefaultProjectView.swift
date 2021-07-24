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
        @State var project: (XcodeProj, PathKit.Path)?
        @State var targetName = ""
        
        var body: some View {
            VStack {
                Form {
                    Section {
                        if let project = project {
                            Text(project.1.string)
                            
                            Picker(selection: $targetName, label: Text("Target"), content: {
                                
                                Text("Please select one target")
                                    .foregroundColor(.secondary)
                                    .tag("")
                                ForEach(project.0.pbxproj.nativeTargets, id: \.name) { target in
                                    Text(target.name).tag(target.name)
                                }
                            })
                        } else {
                            Button("Open a .xcodeproj file") {
                                
                            }
                        }
                    }
                }
                
                if project != nil, !targetName.isEmpty {
                    Button("Open") {
                        
                    }
                }
            }
            
        }
    }
}


struct OpenDefaultProjectView_Previews: PreviewProvider {
    static var previews: some View {
        OpenProjectView.DefaultProjectView(project: (XcodeProj.demoProject.0!, XcodeProj.demoProject.1))
            .frame(width: 500, height: 500)
    }
}
