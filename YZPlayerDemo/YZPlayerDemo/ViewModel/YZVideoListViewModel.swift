//
//  YZVideoListViewModel.swift
//  YZPlayerDemo
//
//  Created by heyuze on 2017/5/12.
//  Copyright © 2017年 heyuze. All rights reserved.
//

import UIKit

class YZVideoListViewModel: NSObject {

    // video 数组
    var videoArr = [YZDemoVideo]()
    
    // 初始化数据
    func setupData(success: ()->Void) {
        let path = Bundle.main.bundlePath
        let filePath = path+"/video"
        
        do {
            let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
            let dataDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : Any]
//            print(dataDict)
            
            let dataArray = dataDict["data"] as! Array<[String : Any]>
            for dict in dataArray {
                let video = YZDemoVideo(dict: dict)
                videoArr.append(video)
            }
            success()
        } catch {
            print(error)
        }
    }
    
}
