//
//  OpenProjectView.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 24/07/2021.
//

import SwiftUI

struct OpenProjectView: View {
    // MARK: - Nested type
    enum ProjectType: String {
        case `default`
        case tuist
    }
    
    // MARK: - State
    @State private var projectType = ProjectType.default
    let handler: OpenProjectHandler
    
    // MARK: - Body
    var body: some View {
        Group {
            Picker("", selection: $projectType) {
                Text("Default project").tag(ProjectType.default)
                Text("Tuist project").tag(ProjectType.tuist)
            }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            
            content
                .padding()
            
            Spacer()
        }
        
    }
    
    var content: AnyView {
        switch projectType {
        case .default:
            return AnyView(DefaultProjectView(handler: handler))
        case .tuist:
            return AnyView(TuistProjectView(handler: handler))
        }
    }
}

#if DEBUG
struct OpenProjectView_Previews: PreviewProvider {
    static var previews: some View {
        OpenProjectView(handler: OpenProjectHandler_Preview())
            .frame(width: 500, height: 500)
    }
}
#endif
