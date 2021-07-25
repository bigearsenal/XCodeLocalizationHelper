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
    @State var isLocalizingProject = false
    
    var body: some View {
        ZStack {
            if viewModel.localizableFiles.isEmpty {
                emptyView
            } else {
                localizableFilesList
            }
        }
        .sheet(isPresented: $isLocalizingProject, content: {
            selectLanaguagesView
        })
    }
    
    fileprivate var emptyView: some View {
        Button("Localize project") {
            isLocalizingProject.toggle()
        }
    }
    
    fileprivate var localizableFilesList: some View {
        List {
            ForEach(viewModel.localizableFiles, id: \.id) { file in
                Text(file.id)
            }
            Image(systemName: "plus.circle.fill")
                .onTapGesture {
                    isLocalizingProject.toggle()
                }
        }
    }
    
    fileprivate var selectLanaguagesView: some View {
        Text("test")
            .frame(width: 400, height: 400, alignment: .center)
    }
}

#if DEBUG
struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(viewModel: .init(project: .default(.demo)))
            .emptyView
        
        ProjectView(viewModel: .init(project: .default(.demo)))
            .localizableFilesList
    }
}
#endif
