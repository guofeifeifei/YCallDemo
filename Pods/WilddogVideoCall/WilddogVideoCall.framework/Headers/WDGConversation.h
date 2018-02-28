//
//  WDGConversation.h
//  WilddogVideoCall
//
//  Created by junpengwang on 10/07/2017.
//  Copyright © 2017 Wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDGVideoCall.h"

typedef NS_ENUM(NSUInteger, WDGCallStatus) {
    WDGCallStatusAccepted,
    WDGCallStatusRejected,
    WDGCallStatusBusy,
    WDGCallStatusTimeout
};

@class WDGRemoteStream;
@class WDGLocalStreamStatsReport;
@class WDGRemoteStreamStatsReport;

@protocol WDGConversationDelegate;
@protocol WDGConversationStatsDelegate;


NS_ASSUME_NONNULL_BEGIN

#pragma mark - WDGConversation Interface

@interface WDGConversation : NSObject

/**
 * 表示视频通话对方的 User ID。
 */
@property (nonatomic, strong , readonly) NSString *remoteUid;

/**
 * 符合 `WDGConversationDelegate` 协议的代理，用于通知 `WDGConversation` 发生的事件。
 */
@property (nonatomic, weak) id<WDGConversationDelegate> delegate;

/**
 符合 `WDGConversationStatsDelegate` 协议的代理。用于获取视频流的统计数据。
 */
@property (nonatomic, weak, nullable) id<WDGConversationStatsDelegate> statsDelegate;


/**
 * 接受对方的视频通话请求，并上传自己的本地媒体流。
 * @param localStream `WDGLocalStream` 实例，表示本地媒体流。
 */
- (void)acceptWithLocalStream:(WDGLocalStream *)localStream;

/**
 * 拒绝视频通话邀请。
 */
- (void)reject;

/**
 * 关闭当前视频通话。
 */
- (void)close;

/**
 * 开始录制视频并保存到本地filePath目录下。
 * @param filePath 视频文件保存路径。
 * @return 视频录制是否成功开启。
 */
- (BOOL)startLocalRecording:(NSString *)filePath;

/**
 * 停止录制视频。
 * @return 视频录制是否成功关闭。
 */
- (BOOL)stopLocalRecording;

@end


#pragma mark - WDGConversation Delegate

@protocol WDGConversationDelegate <NSObject>

@optional

/**
 * `WDGConversation` 通过调用该方法通知代理视频通话状态发生变化。
 * @param conversation 调用该方法的 `WDGConversation` 实例。
 * @param callStatus 表示视频通话的状态，有`Accepted`、`Rejected`、`Busy`、`Timeout` 四种。
 */
- (void)conversation:(WDGConversation *)conversation didReceiveResponse:(WDGCallStatus)callStatus;

/**
 * `WDGConversation` 通过调用该方法通知代理收到对方传来的媒体流。
 * @param conversation 调用该方法的 `WDGConversation` 实例。
 * @param remoteStream `WDGRemoteStream` 实例，表示对方传来的媒体流。
 */
- (void)conversation:(WDGConversation *)conversation didReceiveStream:(WDGRemoteStream *)remoteStream;

/**
 * `WDGConversation` 通过调用该方法通知代理当前视频通话发生错误而未能建立连接。
 * @param conversation 调用该方法的 `WDGConversation` 实例。
 * @param error 错误信息，描述未能建立连接的原因。
 */
- (void)conversation:(WDGConversation *)conversation didFailedWithError:(NSError *)error;

/**
 * `WDGConversation` 通过调用该方法通知代理当前视频通话已被关闭。
 * @param conversation 调用该方法的 `WDGConversation` 实例。
 */
- (void)conversationDidClosed:(WDGConversation *)conversation;

@end


#pragma mark - WDGConversationStats Delegate

@protocol WDGConversationStatsDelegate <NSObject>

@optional

/**
 * `WDGConversation` 通过调用该方法通知代理处理当前视频通话中本地视频流的统计信息。
 * @param conversation 调用该方法的 `WDGConversation` 实例。
 * @param report 包含统计信息的 `WDGLocalStreamStatsReport` 实例。
 */
- (void)conversation:(WDGConversation *)conversation didUpdateLocalStreamStatsReport:(WDGLocalStreamStatsReport *)report;

/**
 * `WDGConversation` 通过调用该方法通知代理处理当前视频通话中远程视频流的统计信息。
 * @param conversation 调用该方法的 `WDGConversation` 实例。
 * @param report 包含统计信息的 `WDGRemoteStreamStatsReport` 实例。
 */
- (void)conversation:(WDGConversation *)conversation didUpdateRemoteStreamStatsReport:(WDGRemoteStreamStatsReport *)report;

@end

NS_ASSUME_NONNULL_END
