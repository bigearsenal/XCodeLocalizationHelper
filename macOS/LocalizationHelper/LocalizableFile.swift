//
//  LocalizableFile.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 12/01/2021.
//

import PathKit

struct LocalizationFile: Identifiable {
    struct Content: Identifiable {
        var key: String
        var value: String
        var id: String {key}
    }
    
    var languageCode: String
    var path: Path
    var content: [Content]
    var isMatching: Bool?
    var id: String { path.string }
    
    // for writing
    var newValue: String
    
    func filteredContent(query: String) -> [Content] {
        if query.isEmpty {
            return Array(content.prefix(5))
        }
        
        return Array(
            content
                .filter {
                    $0.key.lowercased().contains(query.lowercased()) ||
                        $0.value.lowercased().contains(query.lowercased())
                }
                .prefix(5)
        )
    }
}
