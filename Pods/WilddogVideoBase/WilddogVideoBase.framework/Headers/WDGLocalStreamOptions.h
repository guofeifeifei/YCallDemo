//
//  WDGLocalStreamOptions.h
//  WilddogVideo
//
//  Created by Zheng Li on 11/7/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 视频质量选项。
 - WDGVideoDimensions120p: 视频尺寸 192x144
 - WDGVideoDimensions240p: 视频尺寸 352x288
 - WDGVideoDimensions360p: 视频尺寸 480x360
 - WDGVideoDimensions480p: 视频尺寸 640x480
 - WDGVideoDimensions720p: 视频尺寸 1280x720
 - WDGVideoDimensions1080p: 暂不支持，设置此选项视频尺寸为 1280x720
 */
typedef NS_ENUM(NSUInteger, WDGVideoDimensions) {
    WDGVideoDimensions120p,
    WDGVideoDimensions240p,
    WDGVideoDimensions360p,
    WDGVideoDimensions480p,
    WDGVideoDimensions720p,
    WDGVideoDimensions1080p,
};

//摄像头位置
typedef NS_ENUM(NSUInteger, WDGCaptureDevicePosition) {
    //前置摄像头
    WDGCaptureDevicePositionFront,
    //后置摄像头
    WDGCaptureDevicePositionBack
};

NS_ASSUME_NONNULL_BEGIN

/**
 本地视频流配置。
 */
@interface WDGLocalStreamOptions : NSObject

/**
 本地媒体流的音频开关。默认为开。
 */
@property (nonatomic, assign) BOOL shouldCaptureAudio;

/**
 本地媒体流的视频开关，默认为开。
 */
@property (nonatomic, assign) BOOL shouldCaptureVideo;

/**
 控制本地流的初始摄像头朝向。默认使用前置摄像头。
 */
@property(nonatomic, assign) WDGCaptureDevicePosition defaultPosition;

/**
 视频质量选项。默认为 `WDGVideoDimensions480p`。
 */
@property (nonatomic, assign) WDGVideoDimensions dimension;

/**
 表示最大的视频帧率，默认为16fps。
 */
@property (nonatomic, assign) int maxFPS;

/**
 范围50K~2M
 最大最小码率。如果都不设置，系统会使用建议的限制。
 可以只设置其中一个。
 */
@property (nonatomic, strong) NSNumber *_Nullable maxBitrateBps;
@property (nonatomic, strong) NSNumber *_Nullable minBitrateBps;

/**
 使用默认配置初始化。默认配置为音频开启，视频质量使用 `WDGVideoDimensions480p` 选项。

 @return `WDGLocalStreamOptions`实例。
 */
- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
