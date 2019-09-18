//
//  DownloadTaskInfo.swift
//  Practise
//
//  Created by Javed Siddique on 17/09/19.
//  Copyright © 2019 Alpha Plus Technologies. All rights reserved.
//

import Foundation

class Download: NSObject {
    
//    var url:URL?;
//    var isDownloading:Bool = false;
//    var progress:Float = 0.0;
//    var downloadTask:URLSessionDownloadTask?;
//    var downloadTaskId:Int?;
//    var resumeData:Data?;
//    var fileName : String?
//
//
//
//    init(url : URL,fileName : String,isDownloading : Bool) {
//        self.url = url
//        self.fileName = fileName
//        self.isDownloading = isDownloading
//    }
    
    
    
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    var track: DownloadTrack
    
    //
    // MARK: - Initialization
    //
    init(track: DownloadTrack) {
        self.track = track
    }
    
}
