//
//  WDGBeautyVideoView.h
//  WilddogVideo
//
//  Created by Zheng Li on 9/9/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDGVideoView.h"

/**
 `WDGBeautyVideoView` 是 `WDGVideoView` 的子类。
 `WDGVideoStream` 只能与 `WDGBeautyVideoView` 绑定，若要展示 `WDGVideoStream` ，请创建 `WDGBeautyVideoView` 加入到您的视图层级中，再调用 `WDGVideoStream` 的 `- attach:` 方法。

 通过为 `WDGBeautyVideoView` 设置继承自 `UIView` 的 `contentMode` 方法为 `UIViewContentModeScaleToFill`、`UIViewContentModeScaleAspectFit` 和 `UIViewContentModeScaleAspectFill`，可指定视频的显示模式为`拉伸模式`、`等比缩放适应模式` 和 `等比缩放填充`。
 */
__attribute__((deprecated))
@interface WDGBeautyVideoView : WDGVideoView

@end
