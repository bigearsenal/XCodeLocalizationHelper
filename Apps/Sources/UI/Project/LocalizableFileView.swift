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
    
    @Binding var query: String
    @Binding var newValue: String
    
    var body: some View {
        VStack {
            Text(ISOLanguageCode.all.first(where: {file.languageCode == $0.code})?.name ?? file.languageCode)
            ForEach(file.filteredContent(query: query)) { text in
                VStack(alignment: .leading) {
                    Text(text.key)
                        .lineLimit(0)
                        .multilineTextAlignment(.leading)
                    Text(text.value)
                        .lineLimit(0)
                        .multilineTextAlignment(.leading)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            }
            Spacer()
            TextField(file.languageCode, text: $newValue)
                .frame(width: colWidth)
        }
        .frame(width: colWidth)
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
                content: [.init(key: "test", value: "test"), .init(key: "test2", value: "test2")],
                newValue: "t"
            ),
            query: .constant("test"),
            newValue: .constant("new value")
        )
    }
}
#endif
