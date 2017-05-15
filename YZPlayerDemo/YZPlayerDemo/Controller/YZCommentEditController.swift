//
//  VideoCommentEditController.swift
//  Mov
//
//  Created by heyuze on 2016/11/26.
//  Copyright © 2016年 heyuze. All rights reserved.
//

import UIKit

class YZCommentEditController: UIViewController {

    deinit {
        print("VideoCommentEditController deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage.colorImage(color: RGB(r: 0xf6, g: 0xf7, b: 0xf8, alpha: 1)), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        UIApplication.shared.statusBarStyle = .default
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        setupEvent()
        
        textView.becomeFirstResponder()
    }


    // MARK: -  Set up
    
    private func setupUI() {
        navigationController?.navigationBar.layer.shadowColor = RGB(r: 0xee, g: 0xee, b: 0xee, alpha: 1).cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        navigationController?.navigationBar.layer.shadowOpacity = 1
        navigationController?.navigationBar.layer.shadowRadius = 0.5
        navigationItem.titleView = naviTitleLabel(title: "评论")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", target: self, action: #selector(self.sendComment))
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "video_commentClose", target: self, action: #selector(self.close))
        view.backgroundColor = WHITE
        
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(5)
            make.leading.equalTo(view).offset(5)
            make.trailing.equalTo(view).offset(-5)
            make.bottom.equalTo(view).offset(-5)
        }
        
        view.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(13)
            make.leading.equalTo(view).offset(9)
        }
    }
    
    private func setupEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChanged), name: .UITextViewTextDidChange, object: nil)
    }
    
    
    // MARK: - Action
    
    @objc private func sendComment() {
        
    }
    
    @objc private func close() {
        textView.resignFirstResponder()
        dismiss(animated: true) { 
            print("closed")
        }
    }
    
    
    // MARK: - Event
    
    @objc private func textViewDidChanged() {
        if textView.text.characters.count == 0 {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }

    
    // MARK: - Lazy Load
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = BLACK
        return textView
    }()
    
    private lazy var placeholderLabel = UILabel(text: "此时此刻的感想......", textColor: GRAY_99, fontSize: 15)

}
