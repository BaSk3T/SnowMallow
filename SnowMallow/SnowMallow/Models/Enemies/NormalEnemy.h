//
//  NormalEnemy.h
//  SnowMallow
//
//  Created by BaSk3T on 2/6/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MovableSpriteNode.h"

@interface NormalEnemy : SKSpriteNode <MovableSpriteNode>
-(instancetype)initWithPosition:(CGPoint)position andScale:(CGFloat)scale;
+(instancetype) normalEnemyWithPosition:(CGPoint) position andScale:(CGFloat) scale;
+(uint32_t)getCategoryMask;
@property BOOL isMoving;
@property BOOL isGoingLeftDirection;
@property SKAction *animationMoveLeftAction;
@property SKAction *animationMoveRightAction;
@property SKAction *animationRollLeftAction;
@property SKAction *animationRollRightAction;
@property SKAction *moveLeftAction;
@property SKAction *moveRightAction;
@property SKTexture *defaultTexture;
@end
