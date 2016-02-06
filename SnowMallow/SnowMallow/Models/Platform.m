//
//  Platform.m
//  SnowMallow
//
//  Created by BaSk3T on 2/6/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "Platform.h"

@interface Platform()

@end

@implementation Platform
static const uint32_t platformCategory =  0x1 << 1;

-(instancetype)initWithTexture:(SKTexture *)texture andPosition:(CGPoint) position {
    self = [super initWithTexture:texture];
    
    if (self) {
        
        self.anchorPoint = CGPointMake(0, 0);
        self.position = position;
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:texture.size center:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = platformCategory;
    }
    
    return self;
}

+(instancetype)platformWithTexture:(SKTexture *)texture andPosition:(CGPoint)position {
    return [[self alloc] initWithTexture:texture andPosition:position];
}

+(uint32_t)getCategoryMask {
    return platformCategory;
}
@end
