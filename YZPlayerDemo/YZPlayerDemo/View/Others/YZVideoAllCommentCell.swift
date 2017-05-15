//
//  YZVideoAllCommentCell.swift
//  Mov
//
//  Created by heyuze on 2016/11/28.
//  Copyright © 2016年 heyuze. All rights reserved.
//

import UIKit

class YZVideoAllCommentCell: UITableViewCell {
    
    // MARK: - init

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Set up
    
    private func setupUI() {
        backgroundColor = WHITE
        contentView.backgroundColor = WHITE
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
        }
    }
    
    
    // MARK: - Lazy Load
    
    private lazy var titleLabel = UILabel(text: "查看全部评论 >", textColor: BLUE, fontSize: 13)
    
}
