//
//  Character.h
//  SnowMallow
//
//  Created by BaSk3T on 2/5/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MovableSpriteNode.h"

@interface Character : SKSpriteNode <MovableSpriteNode>
-(instancetype) initWithPosition:(CGPoint) position andScale:(CGFloat) scale;
+(instancetype) characterWithPosition:(CGPoint) position andScale:(CGFloat) scale;
+(uint32_t) getCategoryMask;
-(void) moveCharacterIfPossible;
-(void) jump;
-(void) throwSnowBlast;
@property BOOL isMoving;
@property BOOL isFacingLeft;
@property BOOL isJumping;
@property BOOL isAlive;
@property NSNumber *snowBlastPower;
@property SKAction *jumpAction;
@property SKAction *animationJumpLeftAction;
@property SKAction *animationJumpRightAction;
@property SKAction *animationPushLeftAction;
@property SKAction *animationPushRightAction;
@property SKAction *animationThrowLeftAction;
@property SKAction *animationThrowRightAction;
@property SKAction *animationMoveLeftAction;
@property SKAction *animationMoveRightAction;
@property SKAction *animationDestroyedAction;
@property SKAction *moveLeftAction;
@property SKAction *moveRightAction;
@property SKTexture *defaultLeftTexture;
@property SKTexture *defaultRightTexture;
@end
