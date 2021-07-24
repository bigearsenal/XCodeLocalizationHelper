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
        content
            .frame(minWidth: 500, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
    }
    
    var content: AnyView {
        guard let project = viewModel.appState.project
        else {
            return AnyView(OpenProjectView())
        }
        
        switch project {
        case .default(let project):
            return AnyView(Text(project.target.name))
        case .tuist(let project):
            return AnyView(Text(project.resourcePath.string))
        }
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: .init(resolver: .mock))
    }
}
#endif
