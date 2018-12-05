//
//  ImageFixer.swift
//  Chan
//
//  Created by Mikhail Malyshev on 04/12/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class ImageFixer {

    class func fixIfNeeded(image data: Data?) -> UIImage? {
        
        guard let data = data else {
            return nil
        }
        
        if let image = UIImage(data: data) {
            return image
        }
        
        let bytesArray = [UInt8](data)
        
        let headerLength = bytesArray[5] + (bytesArray[4] << 8)
              
        var header = bytesArray[0..<Int(headerLength+4)]
        let body = bytesArray[Int(headerLength+4)..<bytesArray.count]
        
        header += [0, 0]
        header[5] = 16
        
        let patched = header + body
        let newData = Data(bytes: patched)
        
        let image = UIImage(data: newData)
        return image
    }
  
}
