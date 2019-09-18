//
//  DownloadMultipleFileViewController.swift
//  Practise
//
//  Created by Javed Siddique on 16/09/19.
//  Copyright © 2019 Alpha Plus Technologies. All rights reserved.
//

import UIKit



class DownloadMultipleFileViewController: UIViewController {

    var tblHome : UITableView!
    var tblData : [String]! = ["111","222","3333"]
    var fileURl : [String]! = ["http://192.168.1.138/vouchit/123.pdf","http://192.168.1.138/vouchit/124.pdf","http://192.168.1.138/vouchit/555.pdf"]

    
    var arrDownlaodTrack = [DownloadTrack]()
    var arrDownlaod = [Download]()
    
    let downloadSession = URLSession(configuration: .default)
    var activeDownload : [URL: Download] = [:]
    var btndwnlAll : UIButton!
    
    
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let downloadService = DownloadService()
    
    
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier:
            "com.raywenderlich.HalfTunes.bgSession")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        btndwnlAll = UIButton(frame: CGRect(x: 0, y: barHeight, width: 220, height: 60))
        btndwnlAll.setTitle("Download All", for: .normal)
        btndwnlAll.addTarget(self, action: #selector(startallDownload), for: .touchUpInside)
        btndwnlAll.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(btndwnlAll)
        tblHome = UITableView(frame: CGRect(x: 0, y: barHeight+50, width: displayWidth, height: displayHeight - barHeight))
        
        tblHome.delegate = self
        tblHome.dataSource = self
        
        
        
        
        let downlaodTrack1 = DownloadTrack.init(name: tblData[0], previewURL: URL(string:fileURl[0])!,index: 0)
        let downlaodTrack2 = DownloadTrack.init(name: tblData[1], previewURL: URL(string:fileURl[1])!,index: 1)
        let downlaodTrack3 = DownloadTrack.init(name: tblData[2], previewURL: URL(string:fileURl[2])!,index: 2)
        
        arrDownlaodTrack.append(downlaodTrack1)
        arrDownlaodTrack.append(downlaodTrack2)
        arrDownlaodTrack.append(downlaodTrack3)
        
        let downlaod1 = Download.init(track: downlaodTrack1)
        let downlaod2 = Download.init(track: downlaodTrack2)
        let downlaod3 = Download.init(track: downlaodTrack3)

        arrDownlaod.append(downlaod1)
        arrDownlaod.append(downlaod2)
        arrDownlaod.append(downlaod3)
        
        tblHome.register(UINib(nibName: "DownloadTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCell")
        self.view.addSubview(tblHome)
        downloadService.downloadsSession = downloadsSession
        // Do any additional setup after loading the view.
    }
    

    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
//    func startDownload(downloadTrackData : DownloadTrack,downloadCell : DownloadCell){
//        let download = Download(url: downloadTrackData.url, fileName: downloadTrackData.fileName, isDownloading: true)
//        download.downloadTask = downloadSession.downloadTask(with: downloadTrackData.url){location,response,error in
//
//            self.saveData(download: download, location: location, response: response, error: error)
//
//        }
//        download.downloadTask?.resume()
//        download.isDownloading = true
//        downloadCell.updateCell(download: download)
//        //activeDownload[download.url] = download
//    }
//    func startAllFileDownload(downloadTrackData : DownloadTrack){
//        let download = Download(url: downloadTrackData.url, fileName: downloadTrackData.fileName, isDownloading: true)
//        download.downloadTask = downloadSession.downloadTask(with: downloadTrackData.url){location,response,error in
//
//            self.saveData(download: download, location: location, response: response, error: error)
//
//        }
//        download.downloadTask?.resume()
//        download.isDownloading = true
//
//        //activeDownload[download.url] = download
//    }
//
//    func saveData(download : Download,location : URL?,response : URLResponse?,error : Error?){
//
//        let sourceURL = download.url
//        if error != nil{
//            return
//        }
//        //activeDownload[sourceURL] = nil
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as Array
//        let documentDirectory = paths[0] as NSString
//        let path = documentDirectory.appendingPathComponent("\(download.fileName!).pdf")
//        let fileManager = FileManager.default
//        //print("check Path---",path)
//        if(!fileManager.fileExists(atPath: path)){
//            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let documentSavePath = documentsURL.appendingPathComponent("\(download.fileName!).pdf")
//            print("Not Exits save Path---",documentSavePath)
//
//            do {
//                //writing the into the local document directory
//
//                try fileManager.copyItem(at: location!, to: documentSavePath)
//                //let val = try response.data?.write(to: URL(fileURLWithPath: path), options: .atomic)
//                DispatchQueue.main.async {
//                    //OnSuccess
//                    if let index = self.trackIndex(for: download.downloadTask!){
//                        DispatchQueue.main.async {
//                            self.tblHome.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
//                        }
//                    }
//                }
//            } catch {
//                //if their is something error
//                print("Something went wrong!")
//            }
//        }else{
//            //If File Already exits
//            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let documentSavePath = documentsURL.appendingPathComponent("\(download.fileName!).pdf")
//            do{
//                 try fileManager.removeItem(at: documentSavePath)
//            }catch{
//
//            }
//
//        }
//    }
//
//    fileprivate func trackIndex(for task : URLSessionDownloadTask) -> Int?{
//        guard  let url = task.originalRequest?.url else {
//            return nil
//        }
//        let indexedTracks = arrDownlaodTrack.enumerated().filter(){$0.1.url == url}
//        return indexedTracks.first?.0
//    }
    
        
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DownloadMultipleFileViewController:URLSessionDelegate{
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHandler()
            }
        }
    }
}

extension DownloadMultipleFileViewController:URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let sourceURL = downloadTask.originalRequest?.url else {
            return
        }
        
        let download = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil
        
        // 2
        let destinationURL = localFilePath(for: sourceURL)
        print(destinationURL)
        
        // 3
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            download?.track.downloaded = true
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
        
        // 4
        if let index = download?.track.index {
            DispatchQueue.main.async { [weak self] in
                self?.tblHome.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        guard let url = downloadTask.originalRequest?.url,
        let download = downloadService.activeDownloads[url] else {
            return
        }
        
        download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
        DispatchQueue.main.async {
            if let trackCell = self.tblHome.cellForRow(at: IndexPath(row: download.track.index, section: 0)) as? DownloadCell{
                trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
                
                if download.progress == 1.0{
                    self.arrDownlaod[download.track.index].progress = 100
                    self.arrDownlaod[download.track.index].isDownloading = true
                }
            }
        }
    }
}

extension DownloadMultipleFileViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertView = UIAlertController(title: "Hello", message: fileURl[indexPath.row], preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(okAction)
        present(alertView, animated: true, completion: nil)
    }
    
}
extension DownloadMultipleFileViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tblData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblHome.dequeueReusableCell(withIdentifier: "MyCell") as! DownloadCell
        
        //cell.lblTitle.text = downlaodTaskData[indexPath.row].fileName
        //cell.lblPercent.text = "0%"
       
        cell.delegate = self
        cell.conigure(track: arrDownlaodTrack[indexPath.row],
                      download: arrDownlaod[indexPath.row],
                      downloaded: (downloadService.activeDownloads[arrDownlaodTrack[indexPath.row].url] != nil))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
extension DownloadMultipleFileViewController : DownloadCellDelegate{
    
    func startDownload(downloadTaskInfo: DownloadCell) {
        if let indexPath = tblHome.indexPath(for: downloadTaskInfo){
            let downloadData = arrDownlaodTrack[indexPath.row]
            downloadService.startDownload(downloadData)
            tblHome.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        }
    }
    
    @objc func startallDownload() {
        for i in 0..<arrDownlaodTrack.count{
            let downloadData = arrDownlaodTrack[i]
            downloadService.startDownload(downloadData)
            tblHome.reloadRows(at: [IndexPath(row: i, section: 0)], with: .none)
        }
    }
    
    
//    func resumeDownload(downloadTaskInfo: DownloadTableViewCell) {
//        <#code#>
//    }
//
//    func pauseDownload(downloadTaskInfo: DownloadTableViewCell) {
//        <#code#>
//    }
//
//    func cancelDownload(downloadTaskInfo: DownloadTableViewCell) {
//        <#code#>
//    }
    
    
}


