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
        delegate?.startDownload(downloadTaskInfo: self)
    }
    
    func downloadAllTapped(){
        delegate?.startallDownload()
        
    }
    
    func conigure(track : DownloadTrack,download : Download?, downloaded: Bool){
        lblTitle.text = track.fileName
        downloadprogress.progress = 0.0
        //var showDownloadControls = false
        //download!.isDownloading = true
        var showDownloadControls = false
        if let download = download{
            showDownloadControls = true
            lblPercent.text = download.isDownloading ? "100%" : "0%"
            
        }
        selectionStyle = downloaded ? UITableViewCell.SelectionStyle.gray : UITableViewCell.SelectionStyle.none
        btnPauseOrResume.isHidden = true
        btnCancel.isHidden = true
        
        
        downloadprogress.isHidden = download!.isDownloading ? false : true
        lblPercent.isHidden = download!.isDownloading ? false : true
        
        //btnDownload.isHidden = downloaded || showDownloadControls
    }
    
    func updateDisplay(progress: Float, totalSize : String) {
        downloadprogress.progress = progress
        lblPercent.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }
    
}
