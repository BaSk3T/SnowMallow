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
+(instancetype) normalEnemyWithPosition:(CGPoint) position andScale:(CGFloat) scale;

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
