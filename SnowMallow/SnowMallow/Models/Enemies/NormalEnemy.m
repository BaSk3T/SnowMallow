//
//  NormalEnemy.m
//  SnowMallow
//
//  Created by BaSk3T on 2/6/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "NormalEnemy.h"

@interface NormalEnemy()

@property NSArray *moveLeftTextures;
@property NSArray *moveRightTextures;
@property NSArray *rollLeftTextures;
@property NSArray *rollRightTextures;

@end

@implementation NormalEnemy

static const uint32_t enemyCategory =  0x1 << 2;

-(instancetype)initWithPosition:(CGPoint)position andScale:(CGFloat)scale {
    self = [super init];
    
    if (self) {
        self.position = position;
        
        // Fill arrays with textures for given animation
        [self loadDefaultTextures];
        
        // Initiate default texture
        self.texture = self.defaultTexture;
        self.size = CGSizeMake(self.texture.size.width, self.texture.size.height);
        
        // Set size
        self.xScale = scale;
        self.yScale = scale;
        
        // Setting physics
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
        self.physicsBody.dynamic = YES;
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.categoryBitMask = enemyCategory;
        
        // Load all actions
        [self loadActionsForCharacter];

    }
    
    return self;
}

-(void) loadActionsForCharacter {
    self.animationMoveLeftAction = [SKAction animateWithTextures:self.moveLeftTextures timePerFrame:0.15];
    self.animationMoveRightAction = [SKAction animateWithTextures:self.moveRightTextures timePerFrame:0.15];
    self.animationRollLeftAction = [SKAction animateWithTextures:self.rollLeftTextures timePerFrame:0.15];
    self.animationRollRightAction = [SKAction animateWithTextures:self.rollRightTextures timePerFrame:0.15];
    self.moveLeftAction = [SKAction moveByX:-self.size.width / 6 y:0 duration:0.1];
    self.moveRightAction = [SKAction moveByX:self.size.width / 6 y:0 duration:0.1];
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
    SKTexture *defaultTexture = [SKTexture textureWithImageNamed:@"NE-default.png"];
    self.defaultTexture = defaultTexture;
    
    self.moveLeftTextures = [self loadTexturesWithAtlasName:@"NE-MoveLeft" andImagePrefix:@"move-left"];
    self.moveRightTextures = [self loadTexturesWithAtlasName:@"NE-MoveRight" andImagePrefix:@"move-right"];
    self.rollLeftTextures = [self loadTexturesWithAtlasName:@"NE-RollLeft" andImagePrefix:@"roll-left"];
    self.rollRightTextures = [self loadTexturesWithAtlasName:@"NE-ROllRight" andImagePrefix:@"roll-right"];
}


+(instancetype)normalEnemyWithPosition:(CGPoint)position andScale:(CGFloat)scale {
    return [[self alloc] initWithPosition:position andScale:scale];
}
@end
