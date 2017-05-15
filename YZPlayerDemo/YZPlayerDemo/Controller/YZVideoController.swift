//
//  YZVideoController.swift
//  YZPlayerDemo
//
//  Created by heyuze on 2017/5/13.
//  Copyright © 2017年 heyuze. All rights reserved.
//

import UIKit

class YZVideoController: UIViewController {

    var video: YZVideo?
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    deinit {
        print("YZVideoController")
    }
    
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        UIApplication.shared.statusBarStyle = .lightContent
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    // MARK: - Set up
    
    private func setupUI() {
        view.backgroundColor = BACKGROUND_COLOR
        
        view.addSubview(videoToolBar)
        
        view.addSubview(tableView)
        
        view.addSubview(commentView)
        
        view.addSubview(playerView)
        playerView.play()
    }
    // MARK: - Action
    
    fileprivate func commentEdit() {
//        let commentEditController = VideoCommentEditController()
//        presentViewController(UINavigationController(rootViewController: commentEditController), animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - Lazy load
    
    private lazy var playerView: YZPlayerView = {
        let frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: PlayerViewHeight+clearY)
//        let playerView = VideoPlayView(frame: frame, urlString: "http://ogpxf29ue.bkt.clouddn.com/BATTLE_FIELD.mp4")
        let playerView = YZPlayerView(frame: frame)
        playerView.video = self.video
        playerView.delegate = self
        playerView.containerController = self
        return playerView
    }()
    
    private lazy var videoToolBar: YZVideoToolBar = {
        let videoToolBar = YZVideoToolBar(frame: CGRect(x: 0, y: PlayerViewHeight, width: kScreenWidth, height: 40))
        return videoToolBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: PlayerViewHeight+40, width: kScreenWidth, height: kScreenHeight-PlayerViewHeight-40))
        tableView.backgroundColor = BACKGROUND_COLOR
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(YZVideoInfoCell.self, forCellReuseIdentifier: "VideoInfoCell")
        tableView.register(YZVideoAuthorInfoCell.self, forCellReuseIdentifier: "AuthorInfoCell")
        tableView.register(YZVideoSelectionsCell.self, forCellReuseIdentifier: "SelectionsCell")
        tableView.register(YZVideoRecommendMediaCell.self, forCellReuseIdentifier: "RecommendMediaCell")
        tableView.register(YZVideoUserInputCell.self, forCellReuseIdentifier: "UserInputCell")
        tableView.register(YZVideoCommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.register(YZVideoAllCommentCell.self, forCellReuseIdentifier: "AllCommentCell")
        return tableView
    }()
    
    fileprivate lazy var commentView: YZVideoCommentView = {
        let commentView = YZVideoCommentView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight-PlayerViewHeight))
        commentView.commentCallBack = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.commentEdit()
        }
        return commentView
    }()
    
}




// MARK: - TableView Delegate

extension YZVideoController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 1 {
            return 80
        } else if indexPath.section == 2 {
            return 110
        } else if indexPath.section == 3 {
            return recommendMediaHeight+40+40
        } else if indexPath.section == 4 {
            return 110
        } else if indexPath.section == 5{
            return 85
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section ==  6 {
            UIView.animate(withDuration: 0.25, animations: {
                self.commentView.y = PlayerViewHeight
            })
        }
    }
    
}




// MARK: - TableView Data Source

extension YZVideoController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 5 {
            return 3
        }/* else if section == 1 || section == 2 {
         return 0
         }*/
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"VideoInfoCell", for: indexPath)
            return cell
        } else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier:"AuthorInfoCell", for: indexPath)
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"SelectionsCell", for: indexPath)
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"RecommendMediaCell", for: indexPath)
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"UserInputCell", for: indexPath) as! YZVideoUserInputCell
            cell.commentCallBack = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.commentEdit()
            }
            return cell
        } else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"CommentCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"AllCommentCell", for: indexPath)
            return cell
        }
    }
    
}



// MARK: - VideoPlayViewDelegate

extension YZVideoController: YZPlayerViewDelegate {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    // 喜欢video
    func likeAction(){
    
    }
    
}
