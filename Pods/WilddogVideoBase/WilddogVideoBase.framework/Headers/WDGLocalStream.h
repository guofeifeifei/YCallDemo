//
//  WDGLocalStream.h
//  WilddogVideo
//
//  Created by Zheng Li on 8/23/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import "WDGStream.h"
#import <AVFoundation/AVFoundation.h>

@class WDGLocalStreamOptions;
@class WDGLocalStream;

NS_ASSUME_NONNULL_BEGIN


/**
 处理视频流并返回。视频流格式为 'kCVPixelFormatType_420YpCbCr8BiPlanarFullRange'。
 如果返回空，则丢弃当前帧图片。
 */
@protocol WDGLocalStreamDelegate <NSObject>

@optional
- (CVPixelBufferRef)processPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

/**
 `WDGLocalStream` 继承自 `WDGStream` ，具有 `WDGStream` 所有的方法。
 */
@interface WDGLocalStream : WDGStream

@property (weak, nonatomic, nullable) id<WDGLocalStreamDelegate> delegate;

@property (nonatomic , strong , readonly) AVCaptureDevice *cameraDevice;

/**
 继承自 `NSObject` 的初始化方法不可用。

 @return 无效的 `WDGLocalStream` 实例。
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 代表视频流中携带的参数信息,JSON序列化之后长度不能超过2k个字符
 */
@property (nonatomic, strong, readwrite) NSDictionary *_Nullable attributes;

/**
 依照配置创建一个本地视频流。同一时刻只能存在一个本地视频流，若此时已经创建其他视频流，会返回 nil。

 @param options `WDGLocalStreamOptions` 实例。
 @return 创建的本地视频流 `WDGLocalStream` 实例。
 */
- (nullable instancetype)initWithOptions:(WDGLocalStreamOptions *)options NS_DESIGNATED_INITIALIZER;

+ (instancetype)localStreamWithOptions:(WDGLocalStreamOptions *)options;

/**
 关闭当前流，当前流被关闭后不能继续使用。
 */
- (void)close;

/**
 切换摄像头。
 */
- (void)switchCamera;

@end

NS_ASSUME_NONNULL_END
