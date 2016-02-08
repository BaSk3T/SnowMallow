//
//  Ender.h
//  SnowMallow
//
//  Created by BaSk3T on 2/7/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Ender : SKShapeNode
+(uint32_t)getCategoryMask;
-(instancetype) initWithPosition:(CGPoint) position width:(CGFloat) width andHeight:(CGFloat) height;
+(instancetype) enderWithPosition:(CGPoint) position width:(CGFloat) width andHeight:(CGFloat) height;
@end
