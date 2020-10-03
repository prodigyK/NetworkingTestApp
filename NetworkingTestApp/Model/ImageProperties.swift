//
//  ImageProperties.swift
//  NetworkingTestApp
//
//  Created by Admin on 23.09.2020.
//

import UIKit

struct ImageProperties {
    
    let key: String
    let data: Data
    
    init?(key: String, image: UIImage) {
        self.key = key
        guard let data = image.pngData() else { return nil }
        self.data = data
    }
}
