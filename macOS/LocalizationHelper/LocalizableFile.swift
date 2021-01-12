//
//  LocalizableFile.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 12/01/2021.
//

struct LocalizationFile: Identifiable {
    struct Content: Identifiable {
        var key: String
        var value: String
        var id: String {key}
    }
    var languageCode: String
    var url: String
    var newValue: String
    var content: [Content]
    var isMatching: Bool?
    var id: String {
        url
    }
    
    var keys: [String] {content.map {$0.key}}
}
