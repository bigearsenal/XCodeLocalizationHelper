//
//  SelectLanguagesHandler.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 25/07/2021.
//

import Foundation

protocol SelectLanguagesHandler {
    func languagesDidSelect(_ languages: [ISOLanguageCode]) throws
}

#if DEBUG
struct SelectLanguagesHandler_Preview: SelectLanguagesHandler {
    func languagesDidSelect(_ languages: [ISOLanguageCode]) throws {
        print("languages selected: \(languages.map {$0.code})")
    }
}
#endif
