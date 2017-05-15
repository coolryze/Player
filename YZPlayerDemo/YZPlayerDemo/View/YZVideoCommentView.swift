//
//  VideoCommentView.swift
//  Mov
//
//  Created by heyuze on 2016/11/28.
//  Copyright © 2016年 heyuze. All rights reserved.
//

import UIKit


class YZVideoCommentView: UIView {
    
    
    var commentCallBack: (()->())?
    


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
        
        addSubview(commentLabel)
        addSubview(commentNumberLabel)
        addSubview(closeBtn)
        addSubview(iconView)
        addSubview(commentInputBackView)
        addSubview(placeholderLabel)
        addSubview(tableView)
        
        commentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(15)
            make.leading.equalTo(self).offset(15)
            make.height.equalTo(15)
        }
        commentNumberLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(commentLabel.snp.trailing).offset(10)
            make.centerY.equalTo(commentLabel)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(-5)
            make.width.height.equalTo(40)
            make.centerY.equalTo(commentLabel)
        }
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(commentLabel.snp.bottom).offset(18)
            make.leading.equalTo(self).offset(15)
            make.width.height.equalTo(36)
        }
        commentInputBackView.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(10)
            make.trailing.equalTo(self).offset(-15)
            make.height.equalTo(36)
        }
        placeholderLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(commentInputBackView)
            make.leading.equalTo(commentInputBackView).offset(20)
        }
        let lineView = UIView()
        lineView.backgroundColor = BACKGROUND_COLOR
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(100)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(1)
        }

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(100)
            make.leading.trailing.bottom.equalTo(self)
        }
    }
    
    
    
    // MARK: - Data
    
    @objc private func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    @objc private func loadMoreData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    
    
    // MARK: - Action
    
    @objc private func comment() {
        if commentCallBack != nil {
            commentCallBack!()
        }
    }
    
    @objc private func clickCloseBtn() {
        UIView.animate(withDuration: 0.25) { 
            self.y = kScreenHeight
        }
    }
    
    
    
    // MARK: - Lazy Load
    
    private lazy var commentLabel = UILabel(text: "评论", textColor: GRAY, fontSize: 13)
    
    private lazy var commentNumberLabel = UILabel(text: "0", textColor: GRAY_99, fontSize: 11)
    
    private lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "video_commentClose"), for: .normal)
        closeBtn.addTarget(self, action: #selector(self.clickCloseBtn), for: .touchUpInside)
        return closeBtn
    }()
    
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = WHITE
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(YZVideoCommentCell.self, forCellReuseIdentifier: "CommentCell")
        
        let refreshHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refreshData))
        refreshHeader?.stateLabel.isHidden = true
        tableView.mj_header = refreshHeader
        
        let loadMoreFooter = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.loadMoreData))
        loadMoreFooter?.isRefreshingTitleHidden = true
        loadMoreFooter?.isAutomaticallyHidden = true
        loadMoreFooter?.stateLabel.isHidden = true
        tableView.mj_footer = loadMoreFooter

        return tableView
    }()
    
    
}




// MARK: - TableView Delegate 

extension YZVideoCommentView: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

}




// MARK: - TableView Data Source

extension YZVideoCommentView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        return cell
    }

}

