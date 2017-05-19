//
//  YZDemoVideo.swift
//  YZPlayerDemo
//
//  Created by heyuze on 2017/5/12.
//  Copyright © 2017年 heyuze. All rights reserved.
//

import UIKit

class YZDemoVideo: YZVideo {

//    var play_address: String?
    
//    var title: String?
    
    var video_id: Int = 0
    
    var poster: String = ""
    
    var detail: String = ""
    
    var director: String = ""
    
    var actor: String = ""
    
    var comment_number: Int = 0
    
    var like_number: Int = 0
    
    var share_number: Int = 0
    
    var status: Int = 0
    
    var time: Int = 0
    
    var charge: Int = 0
    
    var user_id: Int = 0
    
    var view_number: Int = 0
    
    var length: Int = 0
    
    var play_id: Int = 0
    
    var chapter: Int = 0
    
    var type: Int = 0  // 0:其他, 1:剧集, 2:MV, 3:影视, 4:自制, 5:创作, 6:搞笑
    
    
    // MARK: - 处理数据
    
    var typeString: String {
        get {
            switch type {
            case 1:
                return "剧集"
            case 2:
                return "MV"
            case 3:
                return "影视"
            case 4:
                return "自制"
            case 5:
                return "创作"
            case 6:
                return "搞笑"
            default:
                return "其他"
            }
        }
    }
    
    
    // MARK: - init
    
    override init(dict: [String : Any]) {
        super.init(dict: dict)
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
