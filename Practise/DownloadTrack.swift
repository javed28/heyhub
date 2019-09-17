//
//  DownloadFileInfo.swift
//  Practise
//
//  Created by Javed Siddique on 17/09/19.
//  Copyright © 2019 Alpha Plus Technologies. All rights reserved.
//

import Foundation
struct DownloadTrack : Decodable{
    
    var fileName : String
    var url : URL
    
    enum Codingkeys: String,CodingKey{
        case fileName
        case url
    }
    
}
extension DownloadTrack{
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Codingkeys.self)
        self.fileName =  try container.decode(String.self, forKey: .fileName)
        self.url = URL(string: try container.decode(String.self, forKey: .url))!
    }
}
struct DownloadList : Decodable{
    let results : [DownloadTrack]
}
