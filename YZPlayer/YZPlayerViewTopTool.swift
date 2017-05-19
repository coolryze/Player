//
//  YZPlayerViewTopTool.swift
//  AVPlayerDemo
//
//  Created by heyuze on 2016/11/23.
//  Copyright © 2016年 heyuze. All rights reserved.
//

import UIKit

protocol YZPlayerViewTopToolDelegate: NSObjectProtocol {
    
    func back()
 
    func like(isLike: Bool)
    
}


class YZPlayerViewTopTool: UIView {
    
    weak var delegate: YZPlayerViewTopToolDelegate?
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        printLog("YZPlayerViewTopTool deinit")
    }
    
    
    // MARK: - Set up
    
    private func setupUI() {
        addSubview(backgroundView)
        addSubview(backBtn)
        addSubview(titleLabel)
        addSubview(likeBtn)
        
        setupFrame(isFullScreen: false)
    }
    
    func setupFrame(isFullScreen: Bool) {
        if isFullScreen {
            titleLabel.isHidden = false
            likeBtn.isHidden = false
            backgroundView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
            backgroundView.image = YZPlayerImage(named: "video_topBackground")
            backBtn.frame = CGRect(x: 20, y: 25, width: 40, height: 40)
            titleLabel.frame =  CGRect(x: backBtn.rightX+10, y: 0, width: self.width-200, height: 30)
            titleLabel.centerY = backBtn.centerY
            likeBtn.frame = CGRect(x: self.width-25-40, y: 25, width: 40, height: 40)
        } else {
            likeBtn.isHidden = true
            titleLabel.isHidden = true
            backgroundView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
            backgroundView.image = YZPlayerImage(named: "video_topBackground_small")
            backBtn.frame = CGRect(x: 5, y: 22, width: 40, height: 40)
        }
    }
    
    
    // MARK: - Action
    
    @objc fileprivate func clickBackBtn() {
        if delegate != nil {
            delegate?.back()
        }
    }
    
    @objc fileprivate func clickLikeBtn() {
        let isLike = likeBtn.isSelected
        likeBtn.isSelected = !isLike
        if delegate != nil {
            delegate?.like(isLike: !isLike)
        }
        let animation: CAKeyframeAnimation = CAKeyframeAnimation()
        animation.keyPath = "transform.scale"
        animation.values = [1.0, 1.3, 0.9, 1.0]
        animation.duration = 0.25
        animation.calculationMode = kCAAnimationCubic
        likeBtn.layer.add(animation, forKey: nil)
    }
    
    func likeBtnSelect(selected: Bool) {
        likeBtn.isSelected = selected
    }
    
    
    // MARK: - Lazy load
    
    private lazy var backgroundView = UIImageView()
    
    private lazy var backBtn: UIButton = {
        let backBtn = UIButton()
        backBtn.setImage(YZPlayerImage(named: "video_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(self.clickBackBtn), for: .touchUpInside)
        return backBtn
    }()

    private lazy var titleLabel = UILabel(text: "Title", textColor: WHITE, fontSize: 15)
    
    private lazy var likeBtn: UIButton = {
        let likeBtn = UIButton()
        likeBtn.setImage(YZPlayerImage(named: "video_like"), for: .normal)
        likeBtn.setImage(YZPlayerImage(named: "video_like_sel"), for: .selected)
        likeBtn.addTarget(self, action: #selector(self.clickLikeBtn), for: .touchUpInside)
        return likeBtn
    }()
    
}
