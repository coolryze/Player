//
//  YZVideoListController.swift
//  YZPlayerDemo
//
//  Created by heyuze on 2017/5/12.
//  Copyright © 2017年 heyuze. All rights reserved.
//

import UIKit

private let ImageViewHeight: CGFloat = kScreenWidth * (750/1334)


class YZVideoListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel = YZVideoListViewModel()
    
    
    deinit {
        print("MUMovController deinit")
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.isStatusBarHidden = false
        if tableView.contentOffset.y >= ImageViewHeight {
            UIApplication.shared.statusBarStyle = .default
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
        }
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        viewModel.setupData { [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = BACKGROUND_COLOR
        
        view.addSubview(imageView)
        view.addSubview(logoView)
        view.addSubview(activityIndicator)
        view.addSubview(coverView)
        view.addSubview(tableView)
        
        logoView.center = imageView.center
    }
    
    fileprivate func refreshData() {
        if activityIndicator.isAnimating {
            return
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }

    
    // MARK: - Lazy Load
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: ImageViewHeight))
        imageView.image = UIImage(named: "list_header")
        return imageView
    }()
    
    fileprivate lazy var logoView: UIImageView = UIImageView(image: UIImage(named: "list_daily special"))
    
    fileprivate lazy var coverView: UIView = {
        let coverView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: ImageViewHeight))
        coverView.backgroundColor = RGB(r: 0x00, g: 0x00, b: 0x00, alpha: 0)
        return coverView
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.centerX = self.view.centerX
        activityIndicator.y = self.imageView.height - 25
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: ImageViewHeight))
        headerView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(YZVideoListCell.self, forCellReuseIdentifier: "VideoCell")
        tableView.register(YZListHeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        return tableView
    }()

}



// MARK: - Table View Delegate
extension YZVideoListController {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ListCellHeight+140
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoController = YZVideoController()
        videoController.video = viewModel.videoArr[indexPath.row]
        navigationController?.pushViewController(videoController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            let height = ImageViewHeight-scrollView.contentOffset.y
            let width = kScreenWidth*(1+(-offsetY)/ImageViewHeight)
            let x = -(width-kScreenWidth)*0.5
            let frame = CGRect(x: x, y: 0, width: width, height: height)
            imageView.frame = frame
            logoView.center = imageView.center
            activityIndicator.y = imageView.height - 25
            coverView.backgroundColor = RGB(r: 0x00, g: 0x00, b: 0x00, alpha: 0)
            if offsetY < -50 {
                refreshData()
            }
        } else if offsetY >= 0 {
            let alpha = offsetY/ImageViewHeight
            coverView.backgroundColor = RGB(r: 0x00, g: 0x00, b: 0x00, alpha: alpha*0.9)
            if offsetY >= ImageViewHeight {
                UIApplication.shared.statusBarStyle = .default
            } else {
                UIApplication.shared.statusBarStyle = .lightContent
            }
        }
    }
    
}


// MARK: - Table View Data Source
extension YZVideoListController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.videoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! YZVideoListCell
        cell.video = viewModel.videoArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView")
        return headerView
    }
    
}
