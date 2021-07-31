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
    @State var query: String = ""
    
    var body: some View {
        ZStack {
            if viewModel.localizableFiles.isEmpty {
                emptyView
            } else {
                localizableFilesList
            }
        }
        .onAppear(perform: {
            viewModel.refresh()
        })
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
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(viewModel.localizableFiles, id: \.id) { file in
                    LocalizableFileView(file: file, query: $query, newValue: newValueBinding(file: file))
                    Color(red: 208/255, green: 207/255, blue: 209/255)
                        .frame(width: 1)
                }
                
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .onTapGesture {
                        isLocalizingProject.toggle()
                    }
                    .padding([.leading, .trailing])
            }
            .padding([.leading, .trailing])
        }
    }
    
    fileprivate var selectLanaguagesView: some View {
        SelectLanguageView(
            languages: ISOLanguageCode.all
                .filter {code in
                    !viewModel.localizableFiles.contains(where: {$0.languageCode == code.code})
                },
            isShowing: $isLocalizingProject,
            canSelectMultipleLanguages: true
        ) { languages in
            try? self.viewModel.languagesDidSelect(languages)
        }
            .frame(width: 400, height: 400, alignment: .center)
    }
    
    // MARK: - Helpers
    private func newValueBinding(file: LocalizableFile) -> Binding<String>
    {
        Binding<String>(
            get: {
                file.newValue
            },
            set: {
                var file = file
                file.newValue = $0
                var files = viewModel.localizableFiles
                guard let index = files.firstIndex(where: {$0.id == file.id}) else {return}
                files[index] = file
                viewModel.localizableFiles = files
            }
        )
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
