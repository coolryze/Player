//
//  UIBarButtonItem+Extension.swift
//  MU
//
//  Created by heyuze on 16/7/11.
//  Copyright © 2016年 HYZ. All rights reserved.
//

import UIKit


extension UIBarButtonItem {
    
    
    // 分类里 使用遍历构造器
    convenience init(imageName: String? = nil, title: String? = nil, target: AnyObject?, action: Selector)
    {
        self.init()  //遍历构造器必须调用自己的init
        
        let button = UIButton()
        
        if imageName != nil
        {
            button.setImage(UIImage(named: imageName!), for: UIControlState())
//            button.setImage(UIImage(named: "\(imageName!)_highlighted"), forState: UIControlState.Highlighted)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        }
        
        if title != nil
        {
            button.setTitle(title!, for: UIControlState())
            // 设置字体的大小颜色
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.setTitleColor(BLACK, for: UIControlState())
            button.setTitleColor(BLUE, for: .highlighted)
            button.setTitleColor(RGB(r: 0x66, g: 0x66, b: 0x66, alpha: 0.3), for: .disabled)
        }
        
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        
        button.sizeToFit()
        
        customView = button
    }
    
    
}
