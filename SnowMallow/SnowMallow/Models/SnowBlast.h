//
//  SnowBlast.h
//  SnowMallow
//
//  Created by BaSk3T on 2/7/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MovableSpriteNode.h"

@interface SnowBlast : SKSpriteNode <MovableSpriteNode>
+(instancetype) snowBlastWithPosition:(CGPoint) position andScale:(CGFloat) scale;

@property SKAction *animationMoveSmallAction;
@property SKAction *animationMoveBigAction;
@property SKAction *animationExplodeAction;
@property SKAction *moveLeftAction;
@property SKAction *moveRightAction;
@end
