//
//  DataExtension.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/24/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation

extension Data {
    var hexString: String {
        return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
    
    enum ImageContentType: String {
        case jpeg = "image/jpeg"
        case png = "image/png"
        case gif = "image/gif"
        case tiff = "image/tiff"
    }
    
    var imageContentType: ImageContentType? {
        switch self[0] {
        case 0xFF:
            return .jpeg
        case 0x89:
            return .png
        case 0x47:
            return .gif
        case 0x49, 0x4D:
            return .tiff
        default:
            return nil
        }
    }
    
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8, allowLossyConversion: false) {
            append(data)
        } else {
            assertionFailure("data is invalid")
        }
    }
    
    var byteSize: Int {
        return [UInt8](self).count
    }
}
