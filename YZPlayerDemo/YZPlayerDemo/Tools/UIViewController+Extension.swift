//
//  UIViewController+Extension.swift
//  MU
//
//  Created by heyuze on 16/7/28.
//  Copyright © 2016年 HYZ. All rights reserved.
//

import UIKit

extension UIViewController {

    func naviTitleLabel(title: String) -> UILabel {
        let titleLabel = UILabel(text: title, textColor: BLACK_26, fontSize: 16)
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
        titleLabel.sizeToFit()
        return titleLabel
    }

}
