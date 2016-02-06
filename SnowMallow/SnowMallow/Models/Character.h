//
//  Character.h
//  SnowMallow
//
//  Created by BaSk3T on 2/5/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Character : SKSpriteNode
-(instancetype) initWithPosition:(CGPoint) position andScale:(CGFloat) scale;
+(instancetype) characterWithPosition:(CGPoint) position andScale:(CGFloat) scale;
+(uint32_t) getCategoryMask;
-(void) moveCharacterIfPossible;
-(void) jump;

@property BOOL isMoving;
@property BOOL isGoingLeftDirection;
@property BOOL isJumping;
@property SKAction *jumpAction;
@property SKAction *animationJumpLeftAction;
@property SKAction *animationJumpRightAction;
@property SKAction *animationMoveLeftAction;
@property SKAction *animationMoveRightAction;
@property SKAction *moveLeftAction;
@property SKAction *moveRightAction;
@property SKTexture *defaultLeftTexture;
@property SKTexture *defaultRightTexture;
@end
