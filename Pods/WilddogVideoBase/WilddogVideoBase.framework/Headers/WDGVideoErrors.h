//
//  WDGVideoErrors.h
//  WilddogVideo
//
//  Created by Zheng Li on 9/8/16.
//  Copyright © 2016 WildDog. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef WDG_ERROR_ENUM

#if __has_attribute(ns_error_domain) && (!__cplusplus || __cplusplus >= 201103L)
#define WDG_ERROR_ENUM(type, name, domain)                               \
_Pragma("clang diagnostic push")                                     \
_Pragma("clang diagnostic ignored \"-Wignored-attributes\"")     \
NS_ENUM(type, __attribute__((ns_error_domain(domain))) name) \
_Pragma("clang diagnostic pop")
#else
#define WDG_ERROR_ENUM(type, name, domain) NS_ENUM(type, name)
#endif

#endif

NS_ASSUME_NONNULL_BEGIN

extern NSString *const WDGVideoErrorDomain;

/**
 WilddogVideo 使用的错误码。
 */
typedef WDG_ERROR_ENUM(NSInteger, WDGVideoError, WDGVideoErrorDomain){
    /**
     未知错误。
     */
    WDGVideoErrorUnknown = 40000,
    
    /**
     输入参数无效。
     @note: 详细信息见 `localizedDescription` 字段。
     */
    WDGVideoErrorInvalidArgument = 40001,
    
    /**
     Client初始化失败，Auth token 过期。
     */
    WDGVideoErrorTokenExpired = 41001,
    
    /**
     Client初始化失败，Auth token 错误。
     */
    WDGVideoErrorTokenInvalid = 41002,
    
    /**
     从服务端接口获得 client config 时发生错误。
     */
    WDGVideoErrorGetConfigFailed = 41003,
    
    /**
     视频通话连接失败。
     */
    WDGVideoErrorConversationConnectFailed = 41004,
    
    /**
      无摄像头或麦克风权限（权限不足／未检测到设备）。
     */
    WDGVideoErrorDeviceNotAvailable = 41005,
    
    /**
     操作超时（长时间未响应）。
     */
    WDGVideoErrorOperationTimeOut = 41006,
    
    /**
     Conversation 超时。
     */
    WDGVideoErrorConversationTimeOut = 41007
};

NS_ASSUME_NONNULL_END
