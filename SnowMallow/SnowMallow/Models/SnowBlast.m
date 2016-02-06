//
//  SnowBlast.m
//  SnowMallow
//
//  Created by BaSk3T on 2/7/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "SnowBlast.h"

@interface SnowBlast()
@property NSArray *moveSmallTextures;
@property NSArray *moveBigTextures;
@property NSArray *explodeTextures;

@end

@implementation SnowBlast

static const uint32_t snowBlastCategory =  0x1 << 3;

-(instancetype)initWithPosition:(CGPoint)position andScale:(CGFloat)scale {
    self = [super init];
    
    if (self) {
        self.position = position;
        
        // Fill arrays with textures for given animation
        [self loadDefaultTextures];
        
        SKTexture *textureForSize = self.moveBigTextures[0];
        self.size = CGSizeMake(textureForSize.size.width, textureForSize.size.height);
        
        // Set size
        self.xScale = scale;
        self.yScale = scale;
        
        // Setting physics
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
        self.physicsBody.dynamic = YES;
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.categoryBitMask = snowBlastCategory;
        
        // Load all actions
        [self loadActionsForCharacter];

    }
    
    return self;
}

-(void) loadActionsForCharacter {
    self.animationMoveSmallAction = [SKAction animateWithTextures:self.moveSmallTextures timePerFrame:0.1];
    self.animationMoveBigAction = [SKAction animateWithTextures:self.moveBigTextures timePerFrame:0.1];
    self.animationExplodeAction = [SKAction animateWithTextures:self.explodeTextures timePerFrame:0.1];
    self.moveLeftAction = [SKAction moveByX:-self.size.width y:0 duration:0.1];
    self.moveRightAction = [SKAction moveByX:self.size.width y:0 duration:0.1];
}

// Returns all the textures for given atlas into NSMutableArray
-(NSMutableArray*) loadTexturesWithAtlasName:(NSString*) atlasName andImagePrefix:(NSString*) imagePrefix {
    NSMutableArray *textures = [NSMutableArray array];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
    
    int numberOfImages = (int)atlas.textureNames.count;
    
    for (int i = 1; i <= numberOfImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"%@-%d", imagePrefix, i];
        SKTexture *currentTexture = [atlas textureNamed:textureName];
        [textures addObject:currentTexture];
    }
    
    return textures;
}

// Fills array of textures and sets default left and right textures
-(void) loadDefaultTextures {
    self.moveSmallTextures = [self loadTexturesWithAtlasName:@"SmallBlast" andImagePrefix:@"small-blast"];
    self.moveBigTextures = [self loadTexturesWithAtlasName:@"BigBlast" andImagePrefix:@"big-blast"];
    self.explodeTextures = [self loadTexturesWithAtlasName:@"Explosion" andImagePrefix:@"explode"];
}


+(instancetype)snowBlastWithPosition:(CGPoint)position andScale:(CGFloat)scale {
    return [[self alloc] initWithPosition:position andScale:scale];
}
@end
