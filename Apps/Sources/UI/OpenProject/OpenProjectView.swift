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
    
    // MARK: - Body
    var body: some View {
        VStack {
            Text("Open a project")
                .padding(.top)
                .font(.title)
            Divider()
            Picker("", selection: $projectType) {
                Text("Default project").tag(ProjectType.default)
                Text("Tuist project").tag(ProjectType.tuist)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            content
            
            Spacer()
        }
        
    }
    
    var content: AnyView {
        switch projectType {
        case .default:
            return AnyView(DefaultProjectView())
        case .tuist:
            return AnyView(tuistProjectView)
        }
    }
}

// MARK: - Subviews
extension OpenProjectView {
    var tuistProjectView: some View {
        Form {
            Section {
                Button("Choose \"Resources\" folder") {
                    
                }
            }
        }
    }
}

struct OpenProjectView_Previews: PreviewProvider {
    static var previews: some View {
        OpenProjectView()
            .frame(width: 500, height: 500)
    }
}
