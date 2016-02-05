//
//  Level1.m
//  SnowMallow
//
//  Created by BaSk3T on 2/5/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "Level1.h"
#import "BSJoystick.h"

@implementation Level1
- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        BSJoystick *joystick = [BSJoystick joystickWithJoystickSize:100 stickSize:50 joystickColor:[UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.5] andStickColor:[UIColor redColor]];
        joystick.position = CGPointMake(self.frame.size.width / 6 - 50, self.frame.size.height / 5 - 50);
        
        [self addChild:joystick];
    }
    return self;
}
@end
