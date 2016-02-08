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
-(void) wasHit;
-(void) wasDestroyed;
-(void) rollSnowballInDirection:(BOOL) isFacingLeft;
+(instancetype) normalEnemyWithPosition:(CGPoint) position andScale:(CGFloat) scale;
+(uint32_t)getCategoryMask;
@property BOOL isMoving;
@property BOOL isFacingLeft;
@property BOOL isFreezed;
@property BOOL isPushed;
@property SKAction *animationMoveLeftAction;
@property SKAction *animationMoveRightAction;
@property SKAction *animationRollLeftAction;
@property SKAction *animationRollRightAction;
@property SKAction *animationDisappearAction;
@property SKAction *moveLeftAction;
@property SKAction *moveRightAction;
@property SKAction *pushedLeftAction;
@property SKAction *pushedRightAction;
@property SKTexture *defaultTexture;
@end
