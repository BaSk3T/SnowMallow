//
//  Snowball.h
//  SnowMallow
//
//  Created by BaSk3T on 2/7/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MovableSpriteNode.h"
#import "NormalEnemy.h"

@interface Snowball : SKSpriteNode <MovableSpriteNode>
-(instancetype) initWithPosition:(CGPoint) position enemy:(NormalEnemy*)enemy andScale:(CGFloat) scale;
-(void) updateLevelOfFreezeWithIncrease:(BOOL)increase;
+(uint32_t)getCategoryMask;
+(instancetype) snowballWithPosition:(CGPoint) position enemy:(NormalEnemy*)enemy andScale:(CGFloat) scale;
@property int levelOfFreeze;
@property SKTexture *fullTexture;
@property SKAction *animationAction;

@end
