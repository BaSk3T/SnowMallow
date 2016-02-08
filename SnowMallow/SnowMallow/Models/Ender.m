//
//  Ender.m
//  SnowMallow
//
//  Created by BaSk3T on 2/7/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "Ender.h"

@implementation Ender

static const uint32_t enderCategory =  0x1 << 4;

-(instancetype) initWithPosition:(CGPoint) position width:(CGFloat) width andHeight:(CGFloat) height {
    self = [super init];
    
    if (self) {
        self = (Ender*)[SKShapeNode shapeNodeWithRect:CGRectMake(position.x, position.y, width, height)];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = enderCategory;
        self.lineWidth = 0;
    }
    
    return  self;
}

+(uint32_t)getCategoryMask {
    return enderCategory;
}

+(instancetype) enderWithPosition:(CGPoint) position width:(CGFloat) width andHeight:(CGFloat) height {
    return [[self alloc] initWithPosition:position width:width andHeight:height];
}
@end
