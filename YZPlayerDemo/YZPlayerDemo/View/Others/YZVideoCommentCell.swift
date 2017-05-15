//
//  YZVideoCommentCell.swift
//  Mov
//
//  Created by heyuze on 2016/11/26.
//  Copyright © 2016年 heyuze. All rights reserved.
//

import UIKit


class YZVideoCommentCell: UITableViewCell {


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
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(likeNumberLabel)
        contentView.addSubview(likeBtn)
        contentView.addSubview(commentLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.leading.equalTo(contentView).offset(15)
            make.width.height.equalTo(36)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(15)
            make.leading.equalTo(iconView.snp.trailing).offset(10)
            make.height.equalTo(13)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(7)
            make.height.equalTo(11)
        }
        likeNumberLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(nameLabel)
        }
        likeBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(likeNumberLabel.snp.leading).offset(-5)
            make.centerY.equalTo(likeNumberLabel)
        }
        commentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(12)
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(contentView).offset(-15)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = BACKGROUND_COLOR
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(contentView)
            make.height.equalTo(1)
        }
    }
    
    
    
    // MARK: - Action
    
    @objc private func like() {
        
    }
    
    
    
    // MARK: - Lazy Load
    
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(named: "jinx")
        return iconView
    }()
    
    private lazy var nameLabel = UILabel(text: "Name", textColor: BLACK, fontSize: 13)
    
    private lazy var timeLabel = UILabel(text: "1分钟前", textColor: GRAY_99, fontSize: 11)
    
    private lazy var likeNumberLabel = UILabel(text: "0", textColor: GRAY_99, fontSize: 11)
    
    private lazy var likeBtn: UIButton = {
        let likeBtn = UIButton()
        likeBtn.setImage(UIImage(named: "video_comment_like"), for: .normal)
        likeBtn.addTarget(self, action: #selector(self.like), for: .touchUpInside)
        return likeBtn
    }()

    private lazy var commentLabel: UILabel = {
        let commentLabel = UILabel(text: "Comment...", textColor: BLACK, fontSize: 13)
        commentLabel.numberOfLines = 0
        return commentLabel
    }()
    
    
}
