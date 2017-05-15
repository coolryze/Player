//
//  UIImage+Extension.swift
//  MU
//
//  Created by heyuze on 16/7/8.
//  Copyright © 2016年 HYZ. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



// MARK: - 获取纯色图片

extension UIImage {
    
    class func getScreenImage() -> UIImage
    {
        let window = UIApplication.shared.keyWindow
        
        // 开启图片类型上下文
        UIGraphicsBeginImageContextWithOptions(window!.frame.size, false, 0)
        
        // 把屏幕当前画到图片上下文
        window?.drawHierarchy(in: window!.frame, afterScreenUpdates: false)
        
        // 从图形上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭图片上下文
        UIGraphicsEndImageContext()
        
        return image!
    }

    

    /**
    通过color获取纯色图片
    
    - parameter color: 传入色彩

    - returns: 纯色图片
    */
    class func colorImage(color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor);
        
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        return image!
    }
    
    
    /**
     通过size、color获得纯色图片
     
     - parameter color: 传入color
     - parameter size:  传入size
     
     - returns: 对应size的纯色图片
     */
    class func colorImage(color: UIColor, size: CGSize) -> UIImage {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor);
        
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }

}




// MARK: - 拉伸 / 压缩图片

extension UIImage {
    
    ///对指定图片进行拉伸
    func resizableImage(name: String) -> UIImage {
        
        var normal = UIImage(named: name)!
        let imageWidth = normal.size.width * 0.5
        let imageHeight = normal.size.height * 0.5
        normal = self.resizableImage(withCapInsets: UIEdgeInsetsMake(imageHeight, imageWidth, imageHeight, imageWidth))
        
        return normal
    }
    
    /**
     *  压缩上传图片到指定字节
     *
     *  image     压缩的图片
     *  maxLength 压缩后最大字节大小
     *
     *  return 压缩后图片的二进制
     */
    func compressImage(image: UIImage, maxLength: Int) -> Data? {
        
        let newSize = self.scaleImage(image: image, imageLength: 1242)
        let newImage = self.resizeImage(image: image, newSize: newSize)
        
        var compress:CGFloat = 0.9
        var data = UIImageJPEGRepresentation(newImage, compress)
//        print("origin: \(data?.count)")
        while data?.count > maxLength && compress > 0.01 {
            compress -= 0.02
            data = UIImageJPEGRepresentation(newImage, compress)
        }
        
        return data
    }
    
    /**
     *  通过指定图片最长边，获得等比例的图片size
     *
     *  image       原始图片
     *  imageLength 图片允许的最长宽度（高度）
     *
     *  return 获得等比例的size
     */
    func  scaleImage(image: UIImage, imageLength: CGFloat) -> CGSize {
        
        var newWidth:CGFloat = 0.0
        var newHeight:CGFloat = 0.0
        let width = image.size.width
        let height = image.size.height
        
        if (width > imageLength || height > imageLength){
            
            if (width > height) {
                
                newWidth = imageLength;
                newHeight = newWidth * height / width;
                
            }else if(height > width){
                
                newHeight = imageLength;
                newWidth = newHeight * width / height;
                
            }else{
                
                newWidth = imageLength;
                newHeight = imageLength;
            }
            
            return CGSize(width: newWidth, height: newHeight)
        }
        return image.size
    }
    
    /**
     *  获得指定size的图片
     *
     *  image   原始图片
     *  newSize 指定的size
     *
     *  return 调整后的图片
     */
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func addImage(img:UIImage) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        img.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }    
}
