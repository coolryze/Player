//
//  YZVideoUserInputCell.swift
//  Mov
//
//  Created by heyuze on 2016/11/25.
//  Copyright © 2016年 heyuze. All rights reserved.
//

import UIKit

class YZVideoUserInputCell: UITableViewCell {
    
    var commentCallBack: (()->())?
    
    
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
        
        let toplineView = UIView()
        toplineView.backgroundColor = BACKGROUND_COLOR
        contentView.addSubview(toplineView)
        toplineView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(contentView)
            make.height.equalTo(5)
        }
        
        contentView.addSubview(commentLabel)
        contentView.addSubview(commentNumberLabel)
        contentView.addSubview(iconView)
        contentView.addSubview(commentInputBackView)
        contentView.addSubview(placeholderLabel)
        
        commentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(15)
            make.leading.equalTo(contentView).offset(15)
            make.height.equalTo(15)
        }
        commentNumberLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(commentLabel.snp.trailing).offset(10)
            make.centerY.equalTo(commentLabel)
        }
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(commentLabel.snp.bottom).offset(18)
            make.leading.equalTo(contentView).offset(15)
            make.width.height.equalTo(36)
        }
        commentInputBackView.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).offset(-15)
            make.height.equalTo(36)
        }
        placeholderLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(commentInputBackView)
            make.leading.equalTo(commentInputBackView).offset(20)
        }
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = BACKGROUND_COLOR
        contentView.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(contentView)
            make.height.equalTo(5)
        }
    }
    
    
    // MARK: - Action
    
    @objc private func comment() {
        if commentCallBack != nil {
            commentCallBack!()
        }
    }
    
    
    // MARK: - Lazy Load
    
    private lazy var commentLabel = UILabel(text: "评论", textColor: GRAY, fontSize: 13)
    
    private lazy var commentNumberLabel = UILabel(text: "0", textColor: GRAY_99, fontSize: 11)
    
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(named: "cat")
        return iconView
    }()
    
    private lazy var commentInputBackView: UIView = {
        let commentInputBackView = UIView()
        commentInputBackView.backgroundColor = RGB(r: 0xf1, g: 0xf2, b: 0xfd, alpha: 1)
        commentInputBackView.layer.cornerRadius = 18
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.comment))
        commentInputBackView.addGestureRecognizer(tap)
        return commentInputBackView
    }()
    
    private lazy var placeholderLabel = UILabel(text: "说点什么吧!", textColor: GRAY_99, fontSize: 13)
    
}
