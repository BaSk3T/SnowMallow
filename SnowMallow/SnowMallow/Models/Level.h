//
//  Level.h
//  SnowMallow
//
//  Created by BaSk3T on 2/8/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BSJoystick.h"
#import "Character.h"
#import "Platform.h"
#import "NormalEnemy.h"
#import "SnowBlast.h"
#import "Snowball.h"
#import "Ender.h"

@interface Level : SKScene <SKPhysicsContactDelegate>
-(Platform*) createPlatformWithTextureNamed:(NSString*) textureName orTexture:(SKTexture*) texture andPosition:(CGPoint) position;
-(void)didBeginContact:(SKPhysicsContact *)contact;
-(void)update:(NSTimeInterval)currentTime;
-(void) initializeLevel;
-(void) addStartButton;
-(void) switchToNextLevel;
- (void) prepareForNextLevel;
@property BSJoystick *joystick;
@property Character *character;
@property uint32_t platformCategory;
@property uint32_t characterCategory;
@property uint32_t enemyCategory;
@property uint32_t snowBlastCategory;
@property uint32_t enderCategory;
@property uint32_t snowballCategory;
@property uint32_t levelCategory;
@end
