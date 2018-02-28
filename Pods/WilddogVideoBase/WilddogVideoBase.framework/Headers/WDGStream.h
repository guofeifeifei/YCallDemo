//
//  WDGStream.h
//  WilddogVideo
//
//  Created by Zheng Li on 8/16/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDGVideoView;

NS_ASSUME_NONNULL_BEGIN

/**
 表示可通过 `WDGVideoConversation` 传输的音频和视频流。
 */
@interface WDGStream : NSObject

/**
 代表流中的视频是否开启。
 */
@property (nonatomic, assign) BOOL videoEnabled;

/**
 代表流中的音频是否开启。
 */
@property (nonatomic, assign) BOOL audioEnabled;

/**
 代表视频流中携带的参数信息
 */
@property (nonatomic, strong, readonly) NSDictionary * _Nullable attributes;

/**
 绑定流与视图，使当前流在指定的 `WDGVideoView` 中显示。

 @param view `WDGVideoView` 实例，流在该视图中展示。
 */
- (void)attach:(WDGVideoView *)view;

/**
 解除当前流与指定的 `WDGVideoView` 的绑定。

 @param view `WDGVideoView` 实例，流在该视图中展示。
 */
- (void)detach:(WDGVideoView *)view;

@end

NS_ASSUME_NONNULL_END
