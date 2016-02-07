//
//  Snowball.h
//  SnowMallow
//
//  Created by BaSk3T on 2/7/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MovableSpriteNode.h"

@interface Snowball : SKSpriteNode <MovableSpriteNode>
-(instancetype) initWithPosition:(CGPoint) position andScale:(CGFloat) scale;
-(void) updateLevelOfFreezeWithIncrease:(BOOL)increase;
+(instancetype) snowballWithPosition:(CGPoint) position andScale:(CGFloat) scale;
+(uint32_t)getCategoryMask;
@property int levelOfFreeze;
@property SKAction *animationAction;

@end
