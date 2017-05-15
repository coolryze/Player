//
//  UITabBarViewController+Rotation.swift
//  YZPlayerDemo
//
//  Created by heyuze on 2017/5/15.
//  Copyright © 2017年 heyuze. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    // 重写 shouldAutorotate 属性，保证 TabBarController 嵌套下的控制器能根据自身属性决定是否旋转
    open override var shouldAutorotate: Bool {
        return viewControllers!.last!.shouldAutorotate
    }
    
}
