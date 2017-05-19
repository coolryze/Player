//
//  YZPlayer.swift
//  YZPlayerDemo
//
//  Created by heyuze on 2017/5/15.
//  Copyright © 2017年 heyuze. All rights reserved.
//

import UIKit


// MARK: - Size

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenBounds = UIScreen.main.bounds
let PlayerViewHeight: CGFloat = kScreenWidth * (750/1334)


// MARK: - Color

let WHITE = RGB(r: 0xff, g: 0xff, b: 0xff, alpha: 1)
let BLUE = RGB(r: 0x00, g: 0x56, b: 0xff, alpha: 1)


// MARK: - String

private let ResourcePath = Bundle.main.path(forResource: "Resource", ofType: "bundle")


// MARK: - Function

// 加载 Resource.bundle 存放的图片
func YZPlayerImage(named: String) -> UIImage? {
    let imageName = ResourcePath?.appending("/\(named)")
    let image = UIImage(named: imageName!)
    return image
}

// RGB 颜色
func RGB(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
}

// 自定义 Log
func printLog(_ message: Any, file: String = #file, line: Int = #line, function: String = #function)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(function): \(message)\n")
    #endif
}

