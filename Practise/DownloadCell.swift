//
//  DownloadTableViewCell.swift
//  Practise
//
//  Created by Javed Siddique on 16/09/19.
//  Copyright © 2019 Alpha Plus Technologies. All rights reserved.
//

import UIKit
protocol DownloadCellDelegate: class {
    
    func startDownload(downloadTaskInfo : DownloadCell)
    func startallDownload()
    //    func resumeDownload(downloadTaskInfo : DownloadTableViewCell)
    //    func pauseDownload(downloadTaskInfo : DownloadTableViewCell)
    //    func cancelDownload(downloadTaskInfo : DownloadTableViewCell)
}
class DownloadCell: UITableViewCell {
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblPercent : UILabel!
    @IBOutlet var downloadprogress : UIProgressView!
    
    @IBOutlet var btnDownload : UIButton!
    @IBOutlet var btnPauseOrResume : UIButton!
    @IBOutlet var btnCancel : UIButton!
    weak var delegate: DownloadCellDelegate?
    var arrDownlaod = [Download]()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func pauseOrResumeTapped(_ sender : UIButton){
        
        if btnCancel.titleLabel?.text == "Pause"{
            
        }else{
            
        }
        
    }
    
    @IBAction func cancelTapped(_ sender : UIButton){
        
    }
    
    @IBAction func downloadTapped(_ sender : UIButton){
        //delegate?.startDownload(downloadTaskInfo: self)
        delegate?.startallDownload()
    }
    
    func downloadAllTapped(){
        delegate?.startallDownload()
        
    }
    
    func conigure(track : DownloadTrack,download : Download?,downloaded : Bool){
        lblTitle.text = track.fileName
        arrDownlaod.append(download!)
        var showDownloadControls = false
        
        if let download = download{
            showDownloadControls = true
            lblPercent.text = download.isDownloading ? "Downloading..." : "Paused"
            let title = download.isDownloading ? "Pause" : "Resume"
            btnPauseOrResume.setTitle(title, for: .normal)
        }
        selectionStyle = downloaded ? UITableViewCell.SelectionStyle.gray : UITableViewCell.SelectionStyle.none
        btnPauseOrResume.isHidden = !showDownloadControls
        btnCancel.isHidden = !showDownloadControls
    }
    
}
