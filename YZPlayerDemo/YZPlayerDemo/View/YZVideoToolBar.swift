//
//  VideoToolBar.swift
//  Mov
//
//  Created by heyuze on 2016/11/24.
//  Copyright © 2016年 heyuze. All rights reserved.
//

import UIKit


class YZVideoToolBar: UIView {

    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Set up
    
    private func setupUI() {
        backgroundColor = WHITE
        
        addSubview(likeBtn)
        addSubview(commentBtn)
        addSubview(shareBtn)
        addSubview(reportBtn)
        
        likeBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(5)
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
        }
        commentBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(likeBtn.snp.trailing).offset(5)
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
        }
        shareBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(commentBtn.snp.trailing).offset(5)
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
        }
        reportBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(-5)
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = BACKGROUND_COLOR
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    
    
    // MARK: - Action
    
    @objc private func clickLikeBtn() {
    
    }
    
    @objc private func clickCommentBtn() {
        
    }
    
    @objc private func clickShareBtn() {
        
    }
    
    @objc private func clickReportBtn() {
    
    }
    
    
    
    // MARK: - Lazy load
    
    private lazy var likeBtn: UIButton = {
        let likeBtn = UIButton()
        likeBtn.setImage(UIImage(named: "video_like"), for: .normal)
        likeBtn.addTarget(self, action: #selector(self.clickLikeBtn), for: .touchUpInside)
        return likeBtn
    }()
    
    private lazy var commentBtn: UIButton = {
        let commentBtn = UIButton()
        commentBtn.setImage(UIImage(named: "video_comment1"), for: .normal)
        commentBtn.addTarget(self, action: #selector(self.clickCommentBtn), for: .touchUpInside)
        return commentBtn
    }()
    
    private lazy var shareBtn: UIButton = {
        let shareBtn = UIButton()
        shareBtn.setImage(UIImage(named: "video_share"), for: .normal)
        shareBtn.addTarget(self, action: #selector(self.clickShareBtn), for: .touchUpInside)
        return shareBtn
    }()
    
    private lazy var reportBtn: UIButton = {
        let reportBtn = UIButton()
        reportBtn.setImage(UIImage(named: "video_report"), for: .normal)
        reportBtn.addTarget(self, action: #selector(self.clickReportBtn), for: .touchUpInside)
        return reportBtn
    }()
    
    
}
