//
//  MainView.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 24/07/2021.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        content
    }
    
    var content: AnyView {
        guard let project = viewModel.appState.project
        else {
            return AnyView(openProjectButton)
        }
        
        switch project {
        case .default(let project):
            return AnyView(Text(project.target.name))
        case .tuist(let project):
            return AnyView(Text(project.resourcePath.string))
        }
    }
}

// MARK: - Subviews
extension MainView {
    var openProjectButton: some View {
        Button(action: {
            
        }, label: {
            Text("Open a project")
        })
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: .init(resolver: .mock))
            .frame(width: 680, height: 300)
    }
}
#endif
