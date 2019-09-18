//
//  DownloadFileInfo.swift
//  Practise
//
//  Created by Javed Siddique on 17/09/19.
//  Copyright © 2019 Alpha Plus Technologies. All rights reserved.
//

import Foundation
struct DownloadTrack{
    
    var fileName : String
    var url : URL
    let index: Int
    var downloaded = false
    
    init(name: String, previewURL: URL, index: Int) {
        self.fileName = name
        self.url = previewURL
        self.index = index
    }
}

