//
//  LocalizableFile.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 12/01/2021.
//

import PathKit

public struct LocalizableFile: Identifiable {
    public struct Content: Identifiable {
        public var key: String
        public var value: String
        public var id: String {key}
        public var line: Int
    }
    
    public var languageCode: String
    public var path: Path
    public var content: [Content]
    public var id: String { path.string }
    
    // for writing
    public var newValue: String
    
    public func filteredContent(query: String) -> [Content] {
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
