//
//  DownloadService.swift
//  Practise
//
//  Created by Javed Siddique on 18/09/19.
//  Copyright © 2019 Alpha Plus Technologies. All rights reserved.
//

import Foundation

class DownloadService{
    
    var activeDownloads : [URL : Download] = [:]
    var downloadsSession : URLSession!
    
    func startDownload(_ track: DownloadTrack) {
        // 1
        let download = Download(track: track)
        // 2
        download.task = downloadsSession.downloadTask(with: track.url)
        // 3
        download.task?.resume()
        // 4
        download.isDownloading = true
        // 5
        activeDownloads[download.track.url] = download
    }
    
}
