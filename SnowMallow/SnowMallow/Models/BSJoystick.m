//
//  BSJoystick.m
//  SnowMallow
//
//  Created by BaSk3T on 2/5/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "BSJoystick.h"

@interface BSJoystick()
@property (nonatomic,strong) UITouch *touch;
@property SKShapeNode *innerCircle;
@end

@implementation BSJoystick
- (instancetype)initWithJoystickSize:(CGFloat)joystickSize
                           stickSize:(CGFloat)stickSize
                       joystickColor:(UIColor*) joystickColor
                       andStickColor:(UIColor*) stickColor
{
    self = [super init];
    if (self) {
        
        self.touch = nil;
        self.joystickSize = joystickSize;
        self.stickSize = stickSize;
        self.x = 0;
        self.y = 0;
        
        [self setUserInteractionEnabled:YES];
        self.path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, self.joystickSize, self.joystickSize), nil);
        self.fillColor = joystickColor;
        
        self.innerCircle = [SKShapeNode node];
        self.innerCircle.path = CGPathCreateWithEllipseInRect(CGRectMake(self.joystickSize / 2 - self.stickSize / 2, self.joystickSize / 2 - self.stickSize / 2, self.stickSize, self.stickSize), nil);
        self.innerCircle.fillColor = stickColor;
        
        [self addChild:self.innerCircle];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (!self.touch) {
        self.touch = [touches anyObject];
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    if (!self.touch) {
        return;
    }
    
    CGPoint point = [self.touch locationInNode:self];
    
    CGFloat newX = point.x - self.joystickSize / 2;
    CGFloat newY = point.y - self.joystickSize / 2;
    
    if (newX > self.joystickSize / 2) {
        newX = self.joystickSize / 2;
    }
    else if (newX < -(self.joystickSize / 2)) {
        newX = -(self.joystickSize / 2);
    }
    
    if (newY > self.joystickSize / 2) {
        newY = self.joystickSize / 2;
    }
    else if (newY < -(self.joystickSize / 2)) {
        newY = -(self.joystickSize / 2);
    }
    
    self.x = newX;
    self.y = newY;
    
    //NSLog(@"X:%f Y:%f", self.x, self.y);
    
    CGPoint newPoint = CGPointMake(newX, newY);
    
    self.innerCircle.position = newPoint;
    
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    if ([[touches allObjects] containsObject:self.touch]) {
        self.touch = nil;
        self.innerCircle.position=CGPointMake(0,0);
        self.x = 0;
        self.y = 0;
    }
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if ([[touches allObjects] containsObject:self.touch]) {
        self.touch = nil;
        self.innerCircle.position=CGPointMake(0,0);
        self.x = 0;
        self.y = 0;
    }
}

+(instancetype) joystickWithJoystickSize:(CGFloat)joystickSize stickSize:(CGFloat)stickSize joystickColor:(UIColor *)joystickColor andStickColor:(UIColor *)stickColor {
    return [[self alloc] initWithJoystickSize:joystickSize stickSize:stickSize joystickColor:joystickColor andStickColor:stickColor];
}

@end
