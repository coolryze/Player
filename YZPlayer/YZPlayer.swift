//
//  YZPlayer.swift
//  YZPlayerDemo
//
//  Created by heyuze on 2017/5/15.
//  Copyright © 2017年 heyuze. All rights reserved.
//

import UIKit

private let resourcePath = Bundle.main.path(forResource: "Resource", ofType: "bundle")

// 加载 Resource.bundle 存放的图片
func YZPlayerImage(named: String) -> UIImage? {
    let imageName = resourcePath?.appending("/\(named)")
    let image = UIImage(named: imageName!)
    return image
}

