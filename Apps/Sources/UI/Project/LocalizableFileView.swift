//
//  LocalizableFileView.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 31/07/2021.
//

import SwiftUI
import XcodeProj
import PathKit

struct LocalizableFileView: View {
    let colWidth: CGFloat = 300
    let file: LocalizableFile
    
    let query: String
    @Binding var newValue: String
    
    let removeKeyHandler: (String) -> Void
    
    var body: some View {
        VStack {
            Text(languageName)
                .layoutPriority(1)
            
            ScrollView {
                phraseListView
            }
            
            Spacer()
            
            TextField("Localized string for \(languageName)", text: $newValue)
                .frame(width: colWidth)
                .layoutPriority(1)
                .padding(.bottom, 16)
        }
        .frame(width: colWidth)
    }
    
    // MARK: - Helpers

    private var phraseListView: some View {
        LazyVStack {
            ForEach(file.filteredContent(query: query)) { text in
                phraseView(text: text)
            }
        }
    }
    
    private func phraseView(text: LocalizableFile.Content) -> some View {
        VStack(alignment: .leading) {
            Text(text.key!)
                .lineLimit(0)
                .multilineTextAlignment(.leading)
            Text(text.value!)
                .lineLimit(0)
                .multilineTextAlignment(.leading)
        }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .contextMenu {
                Button(role: .destructive) {
                    removeKeyHandler(text.key!)
                } label: {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            }
            .padding(.bottom, 8)
    }
    
    private var languageName: String {
        ISOLanguageCode.all.first(where: {file.languageCode == $0.code})?.name ?? file.languageCode
    }
}

#if DEBUG
struct LocalizableFileView_Previews: PreviewProvider {
    static var previews: some View {
        let path = XcodeProj.demoProject.1.parent() + "Test1" + "en.lproj" + "/Localizable.strings"
        
        return LocalizableFileView(
            file: .init(
                languageCode: "en",
                path: path,
                content: [
                    .init(
                        offset: 0,
                        length: 4,
                        key: "test",
                        value: "test"
                    ),
                    .init(
                        offset: 0,
                        length: 5,
                        key: "test2",
                        value: "test2"
                    ),
                ],
                newValue: "t"
            ),
            query: "test",
            newValue: .constant("new value"),
            removeKeyHandler: { key in
                
            }
        )
    }
}
#endif
