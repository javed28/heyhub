//
//  DownloadTaskInfo.swift
//  Practise
//
//  Created by Javed Siddique on 17/09/19.
//  Copyright © 2019 Alpha Plus Technologies. All rights reserved.
//

import Foundation

class Download: NSObject {
    
    var url:URL?;
    var isDownloading:Bool = false;
    var progress:Float = 0.0;
    var downloadTask:URLSessionDownloadTask?;
    var downloadTaskId:Int?;
    var resumeData:Data?;
    var fileName : String?
    init(url : URL,fileName : String) {
        self.url = url
        self.fileName = fileName
    }
}
