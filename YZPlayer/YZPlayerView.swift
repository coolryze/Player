//
//  YZPlayerView.swift
//  AVPlayerDemo
//
//  Created by heyuze on 2016/11/18.
//  Copyright © 2016年 heyuze. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

// 枚举
enum ControlType {
    case progressControl
    case voiceControl
    case lightControl
    case noneControl
}

let clearY: CGFloat = 10


protocol YZPlayerViewDelegate: NSObjectProtocol {
    
    // 返回
    func backAction()
    
    // 喜欢video
    func likeAction()
    
}


class YZPlayerView: UIView {
    
    // MARK: - Property
    
    weak var delegate: YZPlayerViewDelegate?
    weak var containerController: UIViewController?

    var video: YZVideo? {
        didSet {
            topTool.title = video?.title
        }
    }
    
    // UI Property
    
    fileprivate var isFullScreen: Bool = false // 是否全屏
    
    fileprivate var isFisrtConfig: Bool = false // 是否是第一次初始化UI
    
    fileprivate var isSeeking: Bool = false // 是否在移动进度条
    
    fileprivate var isHideColumn: Bool = true // 是否隐藏上下栏
    
    fileprivate var hasMoved: Bool = false // 手指是否移动过
    
    fileprivate var touchBeginVoiceValue: Float = 0.0 // 开始触摸时音量
    
    fileprivate var touchBeginLightValue: CGFloat = 0.0 // 开始触摸时亮度
    
    fileprivate var touchBeginPoint: CGPoint = CGPoint.zero  // 开始触摸时的点
    
    fileprivate var controlType: ControlType = .noneControl  // 控制类型
    
    // Player Property
    
//    var urlString: String?

    fileprivate var playerItem: AVPlayerItem?

    fileprivate lazy var player: AVPlayer = {
        let player = AVPlayer()
        self.isFisrtConfig = true
        return player
    }()
    
    fileprivate lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = self.bounds
        playerLayer.frame.size.height -= clearY
        return playerLayer
    }()
    
    fileprivate var playTime: Timer? // timer
    
    fileprivate var isPause: Bool = false // 是否暂停
    
    fileprivate var duration: Float = 0.0 //视频时间长度
    
    fileprivate var currentTime: Float = 0.0 //视频当前进度
    
    fileprivate var volumeView: MPVolumeView?
    
    fileprivate var volumeSlider: UISlider? // 控制声音slier

    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("YZPlayerView deinit")
    }
    
    
    // MARK: - Set up
    
    private func setupUI() {
        // 背景图片视图
        addSubview(backgroundView)
        // playerLayer
        backgroundView.layer.addSublayer(playerLayer)
        // 底部工具条
        addSubview(bottomTool)
        // 顶部工具条
        addSubview(topTool)
        // 播放按钮
        addSubview(playBtn)
        // 返回按钮
        addSubview(backBtn)
        // 时间进度视图(快进时)
        addSubview(timeSheet)
        // 控制声音视图
        creatVolumeView()
        
        bottomTool.isHidden = true
        topTool.isHidden = true
        playBtn.isHidden = true
        timeSheet.isHidden = true
    }
    
    private func creatVolumeView() {
        self.volumeView = MPVolumeView()
        self.volumeView!.showsRouteButton = false
        self.volumeView!.showsVolumeSlider = false
        for view in self.volumeView!.subviews {
            if NSStringFromClass(view.classForCoder) == "MPVolumeSlider" {
                self.volumeSlider = view as? UISlider
                break
            }
        }
        self.addSubview(self.volumeView!)
    }
    
    private func setupEvent() {
        // 监听屏幕旋转
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        // 播放结束
        NotificationCenter.default.addObserver(self, selector: #selector(self.playEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        // 进入后台
        NotificationCenter.default.addObserver(self, selector: #selector(self.resignActiveNotification), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        // 进入前台
        NotificationCenter.default.addObserver(self, selector: #selector(self.becomeActiveNotification), name:NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        // 添加在线视频缓存通知
        self.playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        // AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
        self.playerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    private func addTarget() {
        self.bottomTool.playSlider.addTarget(self, action: #selector(self.sliderValueChanged(_:)), for: .valueChanged)
        self.bottomTool.playSlider.addTarget(self, action: #selector(self.sliderTouchDown(_:)), for: .touchDown)
    }
    
    
    // MARK: - Action
    
    @objc private func clickBackBtn() {
        if isFullScreen {
            toOrientation(orientation: .portrait)
        } else {
            if delegate != nil {
                destoryAVPlayer()
                delegate?.backAction()
            }
        }
    }
    
    @objc private func clickPlayBtn() {
        if playBtn.isSelected {
            self.isPause = true
            // 暂停
            self.pause()
        } else {
            self.isPause = false
            // 播放
            self.goonPlay()
        }
    }
    
    // 隐藏或者显示上下栏手势
    func hideOrShowBtnClick(sender: AnyObject?) {
        // 防止点击底部栏视图隐藏
        let point = sender!.location(in: self)
        var subY =  self.frame.size.height - self.bottomTool.frame.size.height
        if self.isFullScreen == true {
            subY = self.frame.size.width - self.bottomTool.frame.size.height
        }
        let flag: Bool = (point.y < subY) && (point.y != 0) ? true : false
        let topSubY = self.topTool.frame.height
        let topFlag: Bool = (point.y > topSubY) && (point.y != 0) ? true : false
        self.isHideColumn = !self.isHideColumn
        if self.isHideColumn  && flag  && topFlag {
            self.playBtn.isHidden = true
            self.bottomTool.isHidden = true
            self.topTool.isHidden = true
            if self.isFullScreen == true {
                UIApplication.shared.isStatusBarHidden = true
            }
        } else {
            self.playBtn.isHidden = false
            self.bottomTool.isHidden = false
            self.topTool.isHidden = false
            UIApplication.shared.isStatusBarHidden = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.hasMoved = false
        self.touchBeginVoiceValue = self.volumeSlider!.value
        self.touchBeginLightValue = UIScreen.main.brightness
        self.touchBeginPoint = (((touches as NSSet).anyObject() as AnyObject).location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        // 如果移动的距离过于小, 就判断为没有移动
        let tempPoint = ((touches as NSSet).anyObject() as AnyObject).location(in: self)
        if (fabs((tempPoint.x) - self.touchBeginPoint.x) < 15) && (fabs((tempPoint.y) - self.touchBeginPoint.y) < 15) {
            print("移动距离过小")
            return
        } else {
            //self.hasMoved = true
            let tan = fabs(tempPoint.y - self.touchBeginPoint.y) / fabs(tempPoint.x - self.touchBeginPoint.x)
            // 当滑动角度小于30度的时候, 进度手势
            if tan < 1 / sqrt(3) {
                // 进度
                self.controlType = ControlType.progressControl
                self.hasMoved = true
                let value = self.moveProgressControllWithTempPoint(tempPoint)
                self.timeValueChanging(value: value)
                self.isSeeking = true
                self.bottomTool.nowTime = self.timeFormatted(totalSeconds: Int(value))
                self.bottomTool.sliderValue = Float(value) / Float(self.duration)
            } else if tan > 1 / sqrt(3) {
                // 亮度
                if  self.touchBeginPoint.x < self.bounds.size.width / 2  {
                    self.controlType = ControlType.lightControl
                    self.hasMoved = true
                    var tempLightValue = self.touchBeginLightValue - ((tempPoint.y - self.touchBeginPoint.y)/self.bounds.size.height)
                    if tempLightValue < 0 {
                        tempLightValue = 0
                    } else if tempLightValue > 1 {
                        tempLightValue = 1
                    }
                    // 控制亮度的方法
                    UIScreen.main.brightness = tempLightValue
                } else {
                    // 声音
                    self.controlType = ControlType.voiceControl
                    self.hasMoved = true
                    let voiceValue = self.touchBeginVoiceValue - Float((tempPoint.y - self.touchBeginPoint.y)/self.bounds.size.height)
                    if voiceValue < 0 {
                        self.volumeSlider?.value = 0
                    } else if voiceValue > 1 {
                        self.volumeSlider?.value = 1
                    } else {
                        self.volumeSlider?.value = voiceValue
                    }
                }
            }
        }
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if self.hasMoved == true {
            let tempPoint = ((touches as NSSet).anyObject() as AnyObject).location(in: self)
            let value = self.moveProgressControllWithTempPoint(tempPoint)
            self.isSeeking = false
            //播放到
            //let changedTime = CMTimeMakeWithSeconds(Float64(value), 1)
            let cmTime = CMTimeMake(Int64(value), 1)
            //self.player.seekToTime(changedTime)
            if self.controlType == ControlType.progressControl {
                self.pause()
                self.player.seek(to: cmTime, completionHandler: { (finished) in
                    self.goonPlay()
                }) 
            }
            self.timeSheet.isHidden = true
        } else {
            self.hideOrShowBtnClick(sender: (touches as NSSet).anyObject() as AnyObject?)
        }
    }

    
    // MARK: - Operation
    
    func changeVideo(video: YZVideo) {
        self.video = video
        
        guard let url = URL(string: video.play_address!) else {
            print("url 失败")
            return
        }
        self.pause()
        self.removeObserver()
        let playerItem = AVPlayerItem(url: url)
        self.player.replaceCurrentItem(with: playerItem)
        self.playerItem = playerItem
        self.setupEvent()
        self.goonPlay()
    }
    
    private func setupPlayerItem() {
        guard let url = URL(string: video!.play_address!) else {
            print("url 失败")
            return
        }
        playerItem = AVPlayerItem(url: url)
    }
    
    func play() {
        // 初始化PlayerItem
        setupPlayerItem()
        
        if playerItem == nil {
            print("playerItem nil")
            return
        }
        player.replaceCurrentItem(with: playerItem)
        player.play()
        // 监听事件
        setupEvent()
        addTarget()
    }
    
    // 暂停
    fileprivate func pause(){
//        self.isPause = true
        self.playBtn.isSelected = false
        self.player.pause()
        self.playTime?.fireDate = Date.distantFuture
        print("暂停")
    }

    // 继续播放
    fileprivate func goonPlay(){
//        self.isPause = false
        self.playBtn.isSelected = true
        self.player.play()
        self.playTime?.fireDate = Date()
        print("继续播放")
    }
    
    
    // MARK: - Event
    
    @objc private func orientationChanged() {
        let orientation = UIDevice.current.orientation
        
        switch orientation {
        case .portrait:
            toOrientation(orientation: .portrait)
        case .landscapeLeft:
            toOrientation(orientation: .landscapeRight)
        case .landscapeRight:
            toOrientation(orientation: .landscapeLeft)
        case .portraitUpsideDown:
//            toOrientation(.PortraitUpsideDown)
            return
        default: break
        }
    }
    
    // 播放完毕
    @objc private func playEnd(sender: AnyObject) {
        print("播放结束")
//        self.playTime?.invalidate()
        self.pause()
        let cmTime = CMTimeMake(Int64(0), 1)
        self.player.seek(to: cmTime)
    }
    
    @objc private func resignActiveNotification() {
        print("进入后台")
        self.pause()
    }
    
    @objc private func becomeActiveNotification() {
        print("返回前台")
        if self.isPause == false {
            self.goonPlay()
        }
    }
    
    // 计时器方法（处理进度）
    @objc private func progressSliderMove() {
        // 当前时间
        let currentTimeSec = Int(CMTimeGetSeconds(self.player.currentTime()))
        
        self.currentTime = Float(currentTimeSec)
        // 总时间
        let durationTime = Int(self.playerItem!.duration.value)
        let timeScale = Int(self.playerItem!.duration.timescale)
        var totalTime = 0
        if durationTime != 0 {
            totalTime = durationTime / timeScale
        }
        let nowString = self.timeFormatted(totalSeconds: currentTimeSec)
        // 如果不是在移动slider中
        if self.isSeeking == false {
            self.bottomTool.nowTime = nowString
            self.bottomTool.sliderValue = Float(currentTimeSec) / Float(totalTime)
        }
    }
    
    // timeSheet在时间发生变化时所作的操作
    private func timeValueChanging(value: Float) {
        if value > self.currentTime {
            self.timeSheet.isLeft = false
        } else if value < self.currentTime {
            self.timeSheet.isLeft = true
        }
        self.timeSheet.isHidden = false
        let tempTime = self.timeFormatted(totalSeconds: Int(value))
        let totalTime = self.timeFormatted(totalSeconds: Int(self.duration))
        self.timeSheet.timeStr = String(format: "%@ / %@", tempTime,totalTime)
    }
    
    //MARK: - 用来控制移动过程中计算手指划过的时间
    private func moveProgressControllWithTempPoint(_ tempPoint: CGPoint) -> Float {
        var tempVaule: Float = self.currentTime + 90 * Float((tempPoint.x - self.touchBeginPoint.x) / kScreenWidth)
        if tempVaule >= self.duration {
            tempVaule = self.duration
        } else if tempVaule <= 0 {
            tempVaule = 0.0
        }
        return tempVaule
    }

    
    // MARK: - Func
    
    // 开始播放
    func startPlay() {
        self.isFisrtConfig = false
        print("startPlay")
        // 获取总的播放时间
        let durationTime = Int(self.playerItem!.duration.value)
        let timeScale = Int(self.playerItem!.duration.timescale)
        var totalTime = 0
        if durationTime != 0 {
            totalTime = durationTime / timeScale
        }
        self.bottomTool.totalTime = self.timeFormatted(totalSeconds: totalTime)

        if self.playTime != nil {
            self.playTime?.invalidate()
        }
        // 加一个计时器
        self.playTime = Timer(timeInterval: 1, target: self, selector: #selector(self.progressSliderMove), userInfo: nil, repeats: true)
        RunLoop.main.add(self.playTime!, forMode: RunLoopMode.defaultRunLoopMode)
        self.playTime?.fire()
    }
    
    // 计算缓冲进度
    fileprivate func availableDuration() -> Float {
        let ranges = self.player.currentItem?.loadedTimeRanges
        // 获取缓冲区域
        let timeRange = ranges?.first!.timeRangeValue
        let startSeconds = CMTimeGetSeconds((timeRange?.start)!)
        let durationSeconds = CMTimeGetSeconds((timeRange?.duration)!)
        // 计算缓冲总进度
        let result = Float(startSeconds + durationSeconds)
        return result
    }
    
    // 转换时间（00:00）
    fileprivate func timeFormatted(totalSeconds: Int) -> String {
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func destoryAVPlayer() {
        self.playTime?.invalidate()
//        self.player.pause()
//        self.player.replaceCurrentItemWithPlayerItem(nil)
        self.removeObserver()
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
        self.playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self.playerItem?.removeObserver(self, forKeyPath: "status")
    }
    
    func topToolLikeBtnSelect(selected: Bool) {
        topTool.likeBtnSelect(selected: selected)
    }
    
    
    // MARK: - Lazy load
    
    fileprivate lazy var backgroundView: UIImageView = {
        let backgroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height-clearY))
        backgroundView.image = YZPlayerImage(named: "video_bg_media_default")
        return backgroundView
    }()
    
    fileprivate lazy var bottomTool: YZPlayerViewBottomTool = {
        let bottomTool = YZPlayerViewBottomTool(frame: CGRect(x: 0, y: self.height-50-clearY, width: self.width, height: 50+clearY))
        bottomTool.delegate = self
        return bottomTool
    }()
    
    fileprivate lazy var topTool: YZPlayerViewTopTool = {
        let topTool = YZPlayerViewTopTool(frame: CGRect(x: 0, y: 0, width: self.width, height: 64))
        topTool.delegate = self
        return topTool
    }()
    
    fileprivate lazy var timeSheet: YZPlayerTimeSheet = {
        let timeSheet = YZPlayerTimeSheet(frame: CGRect(x: 0, y: 0, width: 150, height: 70))
        timeSheet.layer.cornerRadius = 10
        timeSheet.centerX = self.centerX
        timeSheet.centerY = self.centerY - clearY
        return timeSheet
    }()
    
    fileprivate lazy var playBtn: UIButton = {
        let playBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        playBtn.centerX = self.centerX
        playBtn.centerY = self.centerY - clearY*0.5
        playBtn.setImage(YZPlayerImage(named: "video_play_small"), for: UIControlState())
        playBtn.setImage(YZPlayerImage(named: "video_pause_small"), for: .selected)
        playBtn.addTarget(self, action: #selector(self.clickPlayBtn), for: .touchUpInside)
        return playBtn
    }()
    
    fileprivate lazy var backBtn: UIButton = {
        let backBtn = UIButton(frame: CGRect(x: 5, y: 22, width: 40, height: 40))
        backBtn.setImage(YZPlayerImage(named: "video_back"), for: UIControlState())
        backBtn.addTarget(self, action: #selector(self.clickBackBtn), for: .touchUpInside)
        return backBtn
    }()
    
}



// MARK: - 底部工具栏代理
extension YZPlayerView: YZPlayerViewBottomToolDelegate {
    
    func fullScreen(btn: UIButton) {
        if isFullScreen {
            toOrientation(orientation: .portrait)
        } else {
            toOrientation(orientation: .landscapeRight)
        }
    }
    
}



// MARK: - 顶部工具栏代理
extension YZPlayerView: YZPlayerViewTopToolDelegate {
    
    func back() {
        if isFullScreen {
            toOrientation(orientation: .portrait)
        } else {
            if delegate != nil {
                self.player.pause()
                destoryAVPlayer()
                delegate?.backAction()
            }
        }
    }
    
    func like() {
        if delegate != nil {
            delegate?.likeAction()
        }
    }
    
}



// MARK: - KVO
extension YZPlayerView {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loadedTimeRanges" {
            // 计算缓冲进度
            let timeInterval = self.availableDuration()
            // 计算总播放时间
            let duration = self.playerItem!.duration
            let totalDuration = CMTimeGetSeconds(duration)
            self.duration = Float(totalDuration)
            // 显示缓冲进度
            self.bottomTool.progressValue = timeInterval / Float(totalDuration)
        }  else if keyPath == "status" {
            if self.player.status == .failed {
                print("Failed")
            } else if self.player.status == .readyToPlay {
                print("ReadyToPlay")
                if self.isFisrtConfig == true {
                    self.startPlay()
                    playBtn.isSelected = true
                }
            } else if self.player.status == .unknown {
                print("Unknown")
            }
        }
    }
    
}



// MARK: - Slider
extension YZPlayerView {

    @objc fileprivate func sliderTouchDown(_ slider: UISlider) {
        self.isSeeking = true
        // 暂停播放
        self.pause()
    }
    
    @objc fileprivate func sliderValueChanged(_ slider: UISlider) {
        self.isSeeking = false
        let progress = self.duration * slider.value
        self.currentTime = progress
        self.bottomTool.nowTime = self.timeFormatted(totalSeconds: Int(self.currentTime))
        //播放到
        let cmTime = CMTimeMake(Int64(self.currentTime), 1)
        self.player.seek(to: cmTime, completionHandler: { (finish) in
            //继续播放
            self.goonPlay()
        }) 
    }

}



// MARK: - 以下是处理全屏旋转
extension YZPlayerView {
    
    fileprivate func toOrientation(orientation: UIInterfaceOrientation) {
        let currentOrientation = UIApplication.shared.statusBarOrientation
        if currentOrientation == orientation {
            return
        }
        if orientation == .portrait {
            isFullScreen = false
            // 竖屏
            self.removeFromSuperview()
            self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: PlayerViewHeight+clearY)
            backgroundView.frame = self.frame
            backgroundView.height -= clearY
            playerLayer.frame = self.frame
            playerLayer.frame.size.height -= clearY
            containerController?.view.addSubview(self)
            self.snp.removeConstraints()
            self.snp.makeConstraints({ (make) in
                make.top.leading.trailing.equalTo(self.containerController!.view)
                make.height.equalTo(PlayerViewHeight+clearY)
            })
            self.bottomTool.frame = CGRect(x: 0, y: self.height-50-clearY, width: self.width, height: 50+clearY)
            self.bottomTool.setupFrame(isFullScreen: isFullScreen)
            self.topTool.frame = CGRect(x: 0, y: 0, width: self.width, height: 64)
            self.topTool.setupFrame(isFullScreen: isFullScreen)
            self.playBtn.centerX = self.centerX
            self.playBtn.centerY = self.centerY - clearY
            self.playBtn.setImage(YZPlayerImage(named: "video_play_small"), for: UIControlState())
            self.playBtn.setImage(YZPlayerImage(named: "video_pause_small"), for: .selected)
            self.backBtn.isHidden = false
            self.timeSheet.center = CGPoint(x: self.width*0.5, y: (self.height-clearY)*0.5)
        } else {
            // 横屏
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                isFullScreen = true
                self.removeFromSuperview()
                self.frame = CGRect(x: 0, y: 0, width: kScreenHeight, height: kScreenWidth)
                backgroundView.frame = self.frame
                playerLayer.frame = self.frame
                containerController?.view.addSubview(self)
                self.snp.removeConstraints()
                self.snp.makeConstraints({ (make) in
                    make.size.equalTo(CGSize(width: kScreenHeight, height: kScreenWidth))
                    make.center.equalTo(self.containerController!.view)
                })
                self.bottomTool.frame = CGRect(x: 0, y: self.height-50, width: self.width, height: 50)
                self.bottomTool.setupFrame(isFullScreen: isFullScreen)
                self.topTool.frame = CGRect(x: 0, y: 0, width: self.width, height: 64)
                self.topTool.setupFrame(isFullScreen: isFullScreen)
                self.playBtn.center = self.center
                self.playBtn.setImage(YZPlayerImage(named: "video_play"), for: UIControlState())
                self.playBtn.setImage(YZPlayerImage(named: "video_pause"), for: .selected)
                self.backBtn.isHidden = true
                self.timeSheet.center = CGPoint(x: self.width*0.5, y: self.height*0.5)
            }
        }
        UIApplication.shared.statusBarOrientation = orientation
        if orientation == .portrait {
            UIApplication.shared.isStatusBarHidden = false
        } else {
            UIApplication.shared.isStatusBarHidden = isHideColumn
        }
        UIView.beginAnimations(nil, context: nil)
        // 旋转视频播放的view和显示亮度的view
        self.transform = self.getOrientation(orientation)
        UIView.setAnimationDuration(0.5)
        UIView.commitAnimations()
    }
    
    func getOrientation(_ orientation: UIInterfaceOrientation) -> CGAffineTransform {
        if orientation == .landscapeLeft {
            return CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        } else if orientation == .landscapeRight {
            return CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        }
        return CGAffineTransform.identity
    }
    
}
