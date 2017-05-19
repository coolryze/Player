//
//  YZVideo.swift
//  YZPlayerDemo
//
//  Created by heyuze on 2017/5/16.
//  Copyright © 2017年 heyuze. All rights reserved.
//

import UIKit

class YZVideo: NSObject {

    var play_address: String = "" // 视频播放地址
    
    var title: String = "" // 视频标题

    
    // MARK: - init
    
    init(play_address: String, title: String) {
        super.init()
        self.play_address = play_address
        self.title = title
    }
    
    init(dict: [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
