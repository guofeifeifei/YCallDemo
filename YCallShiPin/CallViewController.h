//
//  CallViewController.h
//  YCallShiPin
//
//  Created by ZZCN77 on 2018/1/26.
//  Copyright © 2018年 ZZCN77. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "GPUImageBrightnessFilter.h"//亮度
#import "GPUImageGrayscaleFilter.h"                 //灰度
#import "GPUImageColorInvertFilter.h"               //反色


@interface CallViewController : UIViewController
@property (nonatomic, copy) NSString *callID;
@property (nonatomic,strong)GPUImageFilterGroup *myFilterGroup;

@end
