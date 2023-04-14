//
//  LocalizableFile.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 12/01/2021.
//

import PathKit
import Foundation

public struct LocalizableFile: Identifiable {
    public struct Content: Identifiable {
        public let line: Int
        
        public let undefinedString: String?
        
        public let key: String?
        public let value: String?
        
        public var id: String {undefinedString ?? key ?? "\(line)"}
        
        init(line: Int, undefinedString: String) {
            self.line = line
            self.undefinedString = undefinedString
            self.key = nil
            self.value = nil
        }
        
        init(line: Int, key: String, value: String) {
            self.line = line
            self.undefinedString = nil
            self.key = key
            self.value = value
        }
    }
    
    public var languageCode: String
    public var path: Path
    public var content: [Content]
    public var id: String { path.string }
    
    // for writing
    public var newValue: String
    
    public func filteredContent(query: String) -> [Content] {
        let content = content
            .compactMap { content -> LocalizableFile.Content? in
                guard content.key != nil && content.value != nil else { return nil }
                return content
            }
        
        if query.isEmpty {
            return Array(content.prefix(5))
        }
        
        return Array(
            content
                .filter {
                    $0.key!.lowercased().contains(query.lowercased()) ||
                        $0.value!.lowercased().contains(query.lowercased())
                }
                .prefix(5)
        )
    }
}
