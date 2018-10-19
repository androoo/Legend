//
//  MarkdownManager.swift
//  Something
//
//  Created by Andrew Ervin Gierke on 7/27/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import UIKit

class MarkdownManager {
    static let shared = MarkdownManager()
    
    static var parser: RCMarkdownParser {
        return shared.parser
    }
    
    let parser = RCMarkdownParser.standardParser
    
    init() {
        let defaultFontSize = MessageTextFontAttributes.defaultFontSize
        
        parser.defaultAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: defaultFontSize)]
        parser.quoteAttributes = [
            NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: defaultFontSize),
            NSAttributedStringKey.backgroundColor: UIColor.codeBackground
        ]
        parser.quoteBlockAttributes = parser.quoteAttributes
        
        var codeAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.backgroundColor.rawValue): UIColor.codeBackground]
        codeAttributes[NSAttributedStringKey.foregroundColor] = UIColor()
        
        if let codeFont = UIFont(name: "Courier New", size: defaultFontSize) {
            codeAttributes[NSAttributedStringKey.font] = codeFont
        }
        
        parser.inlineCodeAttributes = codeAttributes
        parser.codeAttributes = codeAttributes
        
        parser.strongAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: defaultFontSize)]
        parser.italicAttributes = [NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: defaultFontSize)]
        parser.strikeAttributes = [NSAttributedStringKey.strikethroughStyle: NSNumber(value: Int8(NSUnderlineStyle.styleSingle.rawValue))]
        parser.linkAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        
        parser.downloadImage = { urlString, completion in
            guard let url = URL(string: urlString) else { return }
            guard let filename = DownloadManager.filenameFor(urlString) else { return }
            guard let localFileURL = DownloadManager.localFileURLFor(filename) else { return }
            
            func image() -> UIImage? {
                if let data = try? Data(contentsOf: localFileURL) {
                    return UIImage(data: data)
                }
                
                return nil
            }
            
            if DownloadManager.fileExists(localFileURL) {
                completion?(image())
            } else {
                DownloadManager.download(url: url, to: localFileURL) {
                    DispatchQueue.main.async {
                        completion?(image())
                    }
                }
            }
        }
        
        parser.headerAttributes = [
            1: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 26)],
            2: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 24)],
            3: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)],
            4: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]
        ]
    }
    
    func transformAttributedString(_ attributedString: NSAttributedString) -> NSAttributedString {
        return parser.attributedStringFromAttributedMarkdownString(attributedString)
    }
}
