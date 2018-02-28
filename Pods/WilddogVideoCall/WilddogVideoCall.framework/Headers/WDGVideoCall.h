//
//  WDGVideoCall.h
//  WilddogVideoCall
//
//  Created by junpengwang on 10/07/2017.
//  Copyright © 2017 Wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDGConversation;
@class WDGLocalStream;
@class WDGLocalStreamOptions;
@class WDGVideoCallOptions;
@protocol WDGVideoCallDelegate;

NS_ASSUME_NONNULL_BEGIN


#pragma mark - WDGVideoCall Interface

@interface WDGVideoCall : NSObject

/**
 * 符合 `WDGVideoCallDelegate` 协议的代理，用于处理视频通话创建情况。
 */
@property (nonatomic, weak) id<WDGVideoCallDelegate> delegate;

/**
 * 用于获取 `WDGVideoCall`的单例。
 * @return `WDGVideoCall`单例。
 */
+ (instancetype)sharedInstance;

/**
 * 开启／重置与video相关的网络连接。
 */
- (void)start;

/**
 * 断开与video相关的网络连接。
 */
- (void)stop;

/**
 * 邀请其他用户进行视频通话。
 * @param uid 被邀请者的 User ID。
 * @param localStream 本地的媒体流。
 * @param data 可随邀请传递一个 `NSString` 类型的数据。
 * @return `WDGConversation` 实例，代表一次视频通话。
 */
- (WDGConversation *)callWithUid:(NSString *)uid localStream:(WDGLocalStream *)localStream data:(NSString * _Nullable)data __attribute__((deprecated("please use 'callWithUid:localStream:option:'instead")));

/**
 * 邀请其他用户进行视频通话。
 * @param uid 被邀请者的 User ID。
 * @param localStream 本地的媒体流。
 * @param options 相关设置，可携带信息。
 * @return `WDGConversation` 实例，代表一次视频通话。
 */
- (WDGConversation *)callWithUid:(NSString *)uid localStream:(WDGLocalStream *)localStream options:(WDGVideoCallOptions * _Nullable)options;

@end


#pragma mark - WDGVideoCall Delegate

@protocol WDGVideoCallDelegate <NSObject>

@optional

/**
 * `WDGVideoCall` 通过调用该方法通知当前用户收到新的视频通话邀请。
 * @param videoCall 调用该方法的 `WDGVideoCall` 实例。
 * @param conversation 代表收到的视频通话的 `WDGConversation` 实例。
 * @param data 随通话邀请传递的 `NSString` 类型的数据。
 */
- (void)wilddogVideoCall:(WDGVideoCall *)videoCall didReceiveCallWithConversation:(WDGConversation *)conversation data:(NSString * _Nullable)data;

/**
 * `WDGVideoCall` 通过调用该方法通知当前用户配置 `WDGVideoCall` 时发生 token 错误。
 * @param videoCall 调用该方法的 `WDGVideoCall` 实例。
 * @param error 代表错误信息。
 */
- (void)wilddogVideoCall:(WDGVideoCall *)videoCall didFailWithTokenError:(NSError * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
