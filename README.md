# YZPlayer

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/coolryze/YZPlayer/master/LICENSE)&nbsp;
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://www.apple.com/nl/ios/)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%207%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;

A simple video player for iOS, based on AVPlayer. Support the vertical, horizontal screen. Support adjust volume, screen brigtness and video progress. 


# Features

- Rotate automatically according to the screen.
- Support for horizontal and vertical play mode.
- Support play with online URL video file.
- Adjust screen brightness by slide vertical at left side of screen.
- Adjust volume by slide vertical at right side of screen.
- Slide horizontal to fast forward and rewind.


# Requirements

This library requires `iOS 7.0+`, `Swift 3` and `Xcode 8.0+`.


# Usage

#### 1. Add Key `View controller-based status bar appearance` value `NO` to `info.plist`.

#### 2. In your ViewController, override `shouldAutorotate`.

```swift
override var shouldAutorotate : Bool {
    return false
}
```

#### 3. Add YZPlayerView to play video.

```swift
let video = YZVideo(play_address: "https://mu.mumov.com/videogHDk7k6vxjiahC0yPRAXBN3omu", title: "旅游丨柏林的符号学")
let playerView = YZPlayerView()
playerView.video = video
playerView.delegate = self
playerView.containerController = self
self.view.addSubview(playerView)

playerView.play()
```

#### 4. Implements YZPlayerViewDelegate.

  - click `back` button
 
```swift
func backAction() {
    // _ = navigationController?.popViewController(animated: true)
}
```

  - click `like` button

```swift
func likeAction(isLike: Bool) {
    // isLike ? print("like") : print("dislike")
}
```


# License

YZPlayer is provided under the MIT license. See LICENSE file for details.