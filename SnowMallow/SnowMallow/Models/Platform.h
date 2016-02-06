//
//  Platform.h
//  SnowMallow
//
//  Created by BaSk3T on 2/6/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Platform : SKSpriteNode
-(instancetype)initWithTexture:(SKTexture *)texture andPosition:(CGPoint) position;

+(instancetype)platformWithTexture:(SKTexture *)texture andPosition:(CGPoint) position;
+(uint32_t) getCategoryMask;
@end
