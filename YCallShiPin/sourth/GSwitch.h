//
//  GSwitch.h
//  LDNS
//
//  Created by ZZCN77 on 2017/9/20.
//  Copyright © 2017年 ZZCN77. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kNKColorSwitchShapeOval,
    kNKColorSwitchShapeRectangle,
    kNKColorSwitchShapeRectangleNoCorner
} NKColorSwitchShape;

@interface GSwitch : UIControl
<UIGestureRecognizerDelegate>

/* A Boolean value that determines the off/on state of the switch. */
@property (nonatomic, getter = isOn) BOOL on;

/* A value that determines the shape of the switch control */
@property (nonatomic, assign) NKColorSwitchShape shape;

/* The color used to tint the appearance of the switch when it is turned on. */
@property (nonatomic, strong) UIColor *onTintColor;

/* The color used to tint the appearance when the switch is disabled. */
@property (nonatomic, strong) UIColor *tintColor;

/* The color used to tint the appearance of the thumb. */
@property (nonatomic, strong) UIColor *thumbTintColor;

/* Thumb drop shadow on/off */
@property (nonatomic, assign) BOOL shadow;

/* The border color used to tint the appearance when the switch is disabled. */
@property (nonatomic, strong) UIColor *tintBorderColor;

/* The border color used to tint the appearance of the switch when it is turned on. */
@property (nonatomic, strong) UIColor *onTintBorderColor;
@end
