//
//  MainView.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 24/07/2021.
//

import SwiftUI

struct MainView: View {
    // MARK: - Observed objects
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            title
            content
            footer
        }
        .frame(minWidth: 600, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
        
    }
    
    var title: some View {
        var text = "Open a project"
        
        if let project = viewModel.appState.project
        {
            switch project {
            case .default(let project):
                text = project.target.name
            case .tuist(let project):
                text = project.projectName
            }
        }
        
        return Group {
            Text(text)
                .lineLimit(1)
                .truncationMode(.middle)
                .padding(.top, 20)
                .font(.title)
            Divider()
        }
    }
    
    var content: AnyView {
        guard let project = viewModel.appState.project
        else {
            return AnyView(OpenProjectView(handler: viewModel))
        }
        
        return AnyView(ProjectView(viewModel: .init(project: project)))
    }
    
    var footer: some View {
        Group {
            Divider()
            HStack {
                Text("Author: Chung Tran (bigearsenal)")
                Link(url: "https://www.linkedin.com/in/chung-tr%E1%BA%A7n-39b46569/", description: "LinkedIn")
                Link(url: "https://github.com/bigearsenal/XCodeLocalizationHelper", description: "Repository")
                Spacer()
                Link(url: "https://www.buymeacoffee.com/bigearsenal", description: "☕ Buy me a coffee")
                Spacer()
                
                if viewModel.appState.project != nil {
                    Button("Open another...") {
                        viewModel.closeProject()
                    }
                }
                
                Button("Quit") {
                    NSApplication.shared.terminate(self)
                }
            }
            .padding(.bottom, 8)
            .padding(.leading)
            .padding(.trailing)
        }
        
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: .init())
    }
}
#endif
