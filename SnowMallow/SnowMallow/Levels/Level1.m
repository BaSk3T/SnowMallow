//
//  Level1.m
//  SnowMallow
//
//  Created by BaSk3T on 2/5/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "Level1.h"
#import "BSJoystick.h"
#import "Character.h"

@interface Level1()
@property BSJoystick *joystick;
@property Character *character;
@end

@implementation Level1
- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        self.joystick = [BSJoystick joystickWithJoystickSize:100 stickSize:50 joystickColor:[UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.5] andStickColor:[UIColor redColor]];
        self.joystick.position = CGPointMake(self.frame.size.width / 6 - 50, self.frame.size.height / 5 - 50);
        
        self.character = [Character characterWithPosition:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) andScale:2];
        
        [self addChild:self.joystick];
        [self addChild:self.character];
    }
    return self;
}

-(void)update:(NSTimeInterval)currentTime {
    if (self.joystick.x <= 0 - self.joystick.stickSize / 2) {
        SKAction *repeatWalk = [SKAction repeatActionForever:self.character.animationMoveLeftAction];
        
        [self moveCharacterIfPossibleWithAction:repeatWalk];
        
        [self.character runAction:self.character.moveLeftAction];
    }
    else if (self.joystick.x >= 0 + self.joystick.stickSize / 2) {
        SKAction *repeatWalk = [SKAction repeatActionForever:self.character.animationMoveRightAction];
        
        [self moveCharacterIfPossibleWithAction:repeatWalk];
        
        [self.character runAction:self.character.moveRightAction];
    }
    else {
        self.character.isMoving = NO;
    }
    
    if (!self.character.isMoving) {
        [self.character removeActionForKey:@"walk"];
        self.character.texture = self.character.defaultLeftTexture;
    }
    
    if (self.joystick.y >= 0 + self.joystick.stickSize / 2) {
        [self.character jump];
        [self.character runAction:self.character.animationJumpAction];
    }

}

-(void) moveCharacterIfPossibleWithAction:(SKAction*) repeatWalk{
    if (!self.character.isMoving) {
        self.character.isMoving = YES;
        [self.character runAction:repeatWalk withKey:@"walk"];
    }
}
@end
