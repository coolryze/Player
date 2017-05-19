//
//  YZPlayerTimeSheet.swift
//  AVPlayerDemo
//
//  Created by heyuze on 2016/11/24.
//  Copyright © 2016年 heyuze. All rights reserved.
//

import UIKit

class YZPlayerTimeSheet: UIView {
    
    var isLeft: Bool = true {
        didSet {
            if isLeft {
                sheetStateImageView.image = YZPlayerImage(named: "video_progress_left")
            } else {
                sheetStateImageView.image = YZPlayerImage(named: "video_progress_right")
            }
        }
    }
    
    var timeStr: String? {
        didSet {
            sheetTimeLabel.text = timeStr
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
        printLog("YZPlayerTimeSheet deinit")
    }

    
    // MARK: - Set up
    
    private func setupUI() {
        backgroundColor = RGB(r: 0x00, g: 0x00, b: 0x00, alpha: 0.3)
        
        addSubview(sheetStateImageView)
        addSubview(sheetTimeLabel)
    }
    
    
    // MARK: - Lazy Load
    
    private lazy var sheetStateImageView: UIImageView = {
        let sheetStateImageView = UIImageView(frame: CGRect(x: 54, y: 12, width: 43, height: 25))
        sheetStateImageView.image = YZPlayerImage(named: "video_progress_left")
        return sheetStateImageView
    }()
    
    private lazy var sheetTimeLabel: UILabel = {
        let sheetTimeLabel = UILabel(text: "00:00:00 / 00:00:00", textColor: WHITE, fontSize: 12)
        sheetTimeLabel.frame = CGRect(x: 16, y: 49, width: 118, height: 16)
        sheetTimeLabel.textAlignment = .center
        return sheetTimeLabel
    }()
    
}
