//
//  WDGVideoCallOption.h
//  WilddogVideoCall
//
//  Created by problemchild on 2017/11/28.
//  Copyright © 2017年 Wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WDGIceTransportPolicy) {
    WDGIceTransportPolicyAll,
    WDGIceTransportPolicyRelay
};

@interface WDGVideoCallOptions : NSObject

//携带的信息
@property (nonatomic , strong) NSString * _Nullable customData;

//强制Relay选项
@property (nonatomic , assign) WDGIceTransportPolicy iceTransportPolicy;

@end


NS_ASSUME_NONNULL_END
