//
//  GoogleTranslate.swift
//  bigdicts
//
//  Created by Chung Tran on 08/03/2018.
//  Copyright © 2018 Chung Tran. All rights reserved.
//

import Foundation
import Alamofire

public struct GoogleTranslate {
    public enum TranslateError: Error {
        case unknown
    }
    
    public static func translate(text: String, fromLang: String = "auto", toLang: String = "vi", completion: @escaping (Error?, String?) -> Void) {
        // Remember adding the oe=utf-8 and ie=utf-8
        let replacements: [String: String] = [
            "\n":"<N>",
            "%@":"<S>",
            "%d":"<D>"
        ]
        
        var text = text
        for (key, value) in replacements {
            text = text.replacingOccurrences(of: key, with: value)
        }
        
        let url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=\(fromLang)&tl=\(toLang)&dt=t&ie=UTF-8&oe=UTF-8&q=\(text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        print(url)
        AF.request(url)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let value = value as? [Any],
                        value.count > 0,
                        let value2 = value[0] as? [Any],
                        value2.count > 0{
                        var translated = ""
                        for i in value2 {
                            if let value3 = i as? [Any],
                                value3.count > 0,
                                let fraction = value3[0] as? String {
                                translated = translated + " " + fraction
                            }
                        }
                        translated = translated.trimmingCharacters(in: .whitespaces)
                        for (key, value) in replacements {
                            translated = translated.replacingOccurrences(of: value, with: key)
                        }
                        completion(nil, translated)
                        return
                    }
                    completion(TranslateError.unknown, nil)
                    
                case .failure(let error):
                    completion(error, nil)
                }
        }
    }
}

