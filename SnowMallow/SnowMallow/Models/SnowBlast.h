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
-(instancetype)initWithPosition:(CGPoint)position andPower:(NSNumber*)power;
+(instancetype) snowBlastWithPosition:(CGPoint) position andPower:(NSNumber*) power;
@property SKAction *animationMoveAction;
@property SKAction *animationExplodeAction;
@property SKAction *moveLeftAction;
@property SKAction *moveRightAction;
-(void)moveInDirection:(BOOL)isFacingLeft;
@end
