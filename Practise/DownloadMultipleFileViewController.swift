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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tblHome = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        
        tblHome.delegate = self
        tblHome.dataSource = self
        
        let downlaod1 = Download.init(url:URL(string:fileURl[0])!,fileName: tblData[0])
        let downlaod2 = Download.init(url:URL(string:fileURl[1])!,fileName: tblData[0])
        let downlaod3 = Download.init(url:URL(string:fileURl[2])!,fileName: tblData[0])
        
        arrDownlaod.append(downlaod1)
        arrDownlaod.append(downlaod2)
        arrDownlaod.append(downlaod3)
        
        
        let downlaodTrack1 = DownloadTrack(fileName: tblData[0], url: URL(string:fileURl[0])!)
        let downlaodTrack2 = DownloadTrack(fileName: tblData[1], url: URL(string:fileURl[1])!)
        let downlaodTrack3 = DownloadTrack(fileName: tblData[2], url: URL(string:fileURl[2])!)
        
        arrDownlaodTrack.append(downlaodTrack1)
        arrDownlaodTrack.append(downlaodTrack2)
        arrDownlaodTrack.append(downlaodTrack3)
        
        tblHome.register(UINib(nibName: "DownloadTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCell")
        self.view.addSubview(tblHome)
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    

    func startDownload(downloadTrackData : DownloadTrack){
        let download = Download(url: downloadTrackData.url, fileName: downloadTrackData.fileName)
        download.downloadTask = downloadSession.downloadTask(with: downloadTrackData.url){location,response,error in
            self.saveData(download: download, location: location, response: response, error: error)
            
        }
        download.downloadTask?.resume()
        download.isDownloading = true
        //activeDownload[download.url] = download
    }
    
    func saveData(download : Download,location : URL?,response : URLResponse?,error : Error?){
        let sourceURL = download.url
        if error != nil{
            return
        }
        //activeDownload[sourceURL] = nil
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as Array
        let documentDirectory = paths[0] as NSString
        let path = documentDirectory.appendingPathComponent("\(download.fileName!).pdf")
        let fileManager = FileManager.default
        print("check Path---",path)
        if(!fileManager.fileExists(atPath: path)){
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let documentSavePath = documentsURL.appendingPathComponent("\(download.fileName!).pdf")
            print("Not Exits save Path---",documentSavePath)
            do {
                //writing the into the local document directory
                try fileManager.copyItem(at: location!, to: documentSavePath)
                //let val = try response.data?.write(to: URL(fileURLWithPath: path), options: .atomic)
                DispatchQueue.main.async {
                    //OnSuccess
                    if let index = self.trackIndex(for: download.downloadTask!){
                        DispatchQueue.main.async {
                            self.tblHome.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                        }
                    }
                }
            } catch {
                //if their is something error
                print("Something went wrong!")
            }
        }else{
            //If File Already exits
        
        }
    }
   
    fileprivate func trackIndex(for task : URLSessionDownloadTask) -> Int?{
        guard  let url = task.originalRequest?.url else {
            return nil
        }
        let indexedTracks = arrDownlaodTrack.enumerated().filter(){$0.1.url == url}
        return indexedTracks.first?.0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        cell.lblPercent.text = "0%"
        cell.downloadprogress.progress = 0.0
        cell.delegate = self
        cell.conigure(track: arrDownlaodTrack[indexPath.row], download: arrDownlaod[indexPath.row], downloaded: false)
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
            startDownload(downloadTrackData: downloadData)
            tblHome.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        }
    }
    
    func startallDownload() {
        for i in 0..<arrDownlaodTrack.count{
        //if let indexPath = tblHome.indexPath(for: DownloadCell){
            let downloadData = arrDownlaodTrack[i]
            startDownload(downloadTrackData: downloadData)
            tblHome.reloadRows(at: [IndexPath(row: i, section: 0)], with: .none)
       // }
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


