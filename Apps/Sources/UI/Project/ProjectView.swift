//
//  ProjectView.swift
//  LocalizationHelperKit
//
//  Created by Chung Tran on 25/07/2021.
//

import SwiftUI
#if DEBUG
import XcodeProj
#endif

struct ProjectView: View {
    @ObservedObject var viewModel: ProjectViewModel
    
    var body: some View {
        Group {
            Text("Hello, World!")
            Spacer()
        }
        
    }
}

#if DEBUG
struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(viewModel: .init(project: .default(.demo)))
    }
}
#endif
