//
//  BSJoystick.h
//  SnowMallow
//
//  Created by BaSk3T on 2/5/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BSJoystick : SKShapeNode
- (instancetype)initWithJoystickSize:(CGFloat)joystickSize
                           stickSize:(CGFloat)stickSize
                       joystickColor:(UIColor*) joystickColor
                       andStickColor:(UIColor*) stickColor;

+(instancetype) joystickWithJoystickSize:(CGFloat)joystickSize
                               stickSize:(CGFloat)stickSize
                           joystickColor:(UIColor*) joystickColor
                           andStickColor:(UIColor*) stickColor;
@property CGFloat x;
@property CGFloat y;
@property CGFloat joystickSize;
@property CGFloat stickSize;
@end
