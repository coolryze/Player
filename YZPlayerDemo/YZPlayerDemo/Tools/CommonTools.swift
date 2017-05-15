//
//  CommonTools.swift
//  MU
//
//  Created by heyuze on 16/7/8.
//  Copyright © 2016年 HYZ. All rights reserved.
//

import UIKit

// MARK: - 随机字符串
func randomSmallCaseString(length: Int) -> String {
    var output = ""
    for _ in 0..<length {
        let randomNumber = arc4random() % 26 + 97
        let randomChar = Character(UnicodeScalar(randomNumber)!)
        output.append(randomChar)
    }
    return output
}

// MARK: - Color

// 随机颜色
func randomColor() -> UIColor {
    return UIColor(red: CGFloat(arc4random() % 256) / 255, green: CGFloat(arc4random() % 256) / 255, blue: CGFloat(arc4random() % 256) / 255, alpha: 1)
}
public extension UIColor {
    public convenience init(colorHex: UInt32, alpha: CGFloat = 1.0) {
        let red     = CGFloat((colorHex & 0xFF0000) >> 16) / 255.0
        let green   = CGFloat((colorHex & 0x00FF00) >> 8 ) / 255.0
        let blue    = CGFloat((colorHex & 0x0000FF)      ) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// MARK: - 时间
// 秒数转换为时间
func secondsConverToTimeStr(seconds: Int) -> String {
    if seconds >= 3600 {
        let hour = seconds / 3600
        let minute = (seconds - 3600*hour) / 60
        let second = seconds % 60
        return String.init(format: "%02d:%02d:%02d", hour, minute, second)
    } else {
        let minute = seconds / 60
        let second = seconds % 60
        return String.init(format: "%02d:%02d", minute, second)
    }
}

// 把时间戳和当前时间做比较，转换为xxx天前
func compareNowTimeToStr(time: Int) -> String {
    let nowTime = Int(Date().timeIntervalSince1970)
    let diffSecond = nowTime - time
    
    if diffSecond < 60 {
        return "\(diffSecond)秒前"
    } else if diffSecond < 3600 {
        let minute = diffSecond / 60
        return "\(minute)分钟前"
    } else if diffSecond < 3600*24 {
        let hour = diffSecond / 3600
        return "\(hour)小时前"
    } else {
        let day = diffSecond / (3600*24)
        return "\(day)天前"
    }
}

func convertToDate(time: Int) -> String {
    let timeDouble = Double(time)
    // 时间转换
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat="yyyy/MM/dd"
    let date = Date.init(timeIntervalSince1970: timeDouble)
    let dateStr = dateFormatter.string(from: date)
    return dateStr
}

// 获取时间长度
func getTimeLengthStr(length: Int) -> String {
    let minute = length / 60
    let second = length % 60
    let lengthStr = String.init(format: "%02d′%02d″", minute, second)
    return lengthStr
}


/*
// MARK: - 自定义Log
func printLog(_ message: Any, file: String = #file, line: Int = #line, function: String = #function)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(function): \(message)\n")
    #endif
}
*/

