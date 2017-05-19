//
//  YZPlayerViewBottomTool.swift
//  AVPlayerDemo
//
//  Created by heyuze on 2016/11/21.
//  Copyright © 2016年 heyuze. All rights reserved.
//

import UIKit

protocol YZPlayerViewBottomToolDelegate: NSObjectProtocol{
    
    func fullScreen(btn: UIButton)  //全屏、取消
    
}


class YZPlayerViewBottomTool: UIView {

    weak var delegate: YZPlayerViewBottomToolDelegate?
    
    var progressValue: Float = 0.0 {
        didSet {
            loadProgress.progress = progressValue
        }
    }
    
    var sliderValue: Float = 0.0 {
        didSet {
            playSlider.value = sliderValue
        }
    }
    
    var nowTime: String? {
        didSet {
            timeLabel.text = nowTime
        }
    }
    
    var totalTime: String? {
        didSet {
            durationLabel.text = totalTime
        }
    }
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        printLog("YZPlayerViewBottomTool deinit")
    }
    
    
    // MARK: - Set up
    
    private func setupUI() {
        addSubview(backgroundView)
        addSubview(timeLabel)
        addSubview(durationLabel)
        addSubview(loadProgress)
        addSubview(playSlider)
        addSubview(fullScreenBtn)
        
        setupFrame(isFullScreen: false)
    }
    
    func setupFrame(isFullScreen: Bool) {
        if isFullScreen {
            //全屏模式
            backgroundColor = RGB(r: 0x00, g: 0x00, b: 0x00, alpha: 0.3)
            
            timeLabel.isHidden = false
            durationLabel.isHidden = false
            backgroundView.isHidden = true
            fullScreenBtn.isHidden = true
            
            playSlider.setThumbImage(YZPlayerImage(named: "video_sliderControl"), for: .normal)
            backgroundView.frame = CGRect.zero
            timeLabel.frame = CGRect(x: 25, y: 15, width: timeLabel.width, height: timeLabel.height)
            durationLabel.frame = CGRect(x: self.width-25-durationLabel.width, y: 15, width: durationLabel.width, height: durationLabel.height)
            loadProgress.frame = CGRect(x: timeLabel.rightX+10, y: 15, width: self.width-timeLabel.width-durationLabel.width-50-20, height: loadProgress.height)
            playSlider.frame = CGRect(x: timeLabel.rightX+10-2, y: 15, width: self.width-timeLabel.width-durationLabel.width-50-20+4, height: playSlider.height)
            loadProgress.centerY = timeLabel.centerY
            playSlider.centerY = timeLabel.centerY
        } else {
            // 竖屏模式
            backgroundColor = UIColor.clear
            
            timeLabel.isHidden = true
            durationLabel.isHidden = true
            fullScreenBtn.isHidden = false
            backgroundView.isHidden = false
            
            playSlider.setThumbImage(YZPlayerImage(named: "video_sliderControl_small"), for: .normal)
            backgroundView.image = YZPlayerImage(named: "video_bottomBackground_small")
            backgroundView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height-clearY)
            loadProgress.frame = CGRect(x: 0, y: self.height-loadProgress.height-clearY, width: self.width, height: loadProgress.height)
            playSlider.frame = CGRect(x: 0-2, y: self.height-playSlider.height-clearY, width: self.width+4, height: playSlider.height)
            playSlider.centerY = loadProgress.centerY
            fullScreenBtn.frame = CGRect(x: self.width-45, y: 0, width: 40, height: 40)
        }
    }
    
    
    // MARK: - Action
    
    @objc private func clickFullScreenBtn() {
        if delegate != nil {
            delegate?.fullScreen(btn: fullScreenBtn)
        }
    }
    
    
    // MARK: - Lazy load
    
    private lazy var backgroundView = UIImageView()
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel(text: "00:00:00", textColor: WHITE, fontSize: 10)
        timeLabel.sizeToFit()
        return timeLabel
    }()
    
    private lazy var durationLabel: UILabel = {
        let durationLabel = UILabel(text: "00:00:00", textColor: WHITE, fontSize: 10)
        durationLabel.textAlignment = .right
        durationLabel.sizeToFit()
        return durationLabel
    }()
    
    lazy var playSlider: UISlider = {
        let playSlider = UISlider()
        playSlider.isContinuous = false
        playSlider.setThumbImage(YZPlayerImage(named: "video_sliderControl_small"), for: .normal)
        playSlider.minimumTrackTintColor = BLUE
        playSlider.maximumTrackTintColor = UIColor.clear
        playSlider.maximumValue = 1.0
        playSlider.value = 0.0
        return playSlider
    }()
    
    private lazy var loadProgress: UIProgressView = {
        let loadProgress = UIProgressView()
        loadProgress.progressTintColor = UIColor.lightGray
        loadProgress.trackTintColor = UIColor.darkGray
        loadProgress.progress = 0.0
        return loadProgress
    }()
    
    private lazy var fullScreenBtn: UIButton = {
        let fullScreenBtn = UIButton()
        fullScreenBtn.setImage(YZPlayerImage(named: "video_fullScreen"), for: .normal)
        fullScreenBtn.addTarget(self, action: #selector(self.clickFullScreenBtn), for: .touchUpInside)
        return fullScreenBtn
    }()
    
}
