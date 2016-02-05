//
//  Character.m
//  SnowMallow
//
//  Created by BaSk3T on 2/5/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "Character.h"

@interface Character()
@property NSArray *moveLeftTextures;
@property NSArray *moveRightTextures;
@property NSArray *jumpTextures;
@end

@implementation Character
-(instancetype) initWithPosition:(CGPoint)position andScale:(CGFloat) scale {
    self = [super init];
    
    if (self) {
        self.position = position;
        
        // Fill arrays with textures for given animation
        [self loadDefaultTextures];
        
        // Initiate default texture
        self.texture = self.defaultLeftTexture;
        self.size = CGSizeMake(self.texture.size.width, self.texture.size.height);
        
        // Set size
        self.xScale = scale;
        self.yScale = scale;
        
        // Setting physics
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
        self.physicsBody.mass = 1.0;
        self.physicsBody.dynamic = YES;
        
        // Load all actions
        [self loadActionsForCharacter];
    }
    
    return self;
}

-(void)jump {
    [self.physicsBody applyImpulse:CGVectorMake(0, 500.0) atPoint:self.position];
}

-(void) loadActionsForCharacter {
    self.animationJumpAction = [SKAction animateWithTextures:self.jumpTextures timePerFrame:0.1];
    self.animationMoveLeftAction = [SKAction animateWithTextures:self.moveLeftTextures timePerFrame:0.15];
    self.animationMoveRightAction = [SKAction animateWithTextures:self.moveRightTextures timePerFrame:0.15];
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
    NSString *atlasName = @"Default";
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
    
    SKTexture *defaultLeft = [atlas textureNamed:@"default-left"];
    SKTexture *defaultRight = [atlas textureNamed:@"default-right"];
    
    self.defaultLeftTexture = defaultLeft;
    self.defaultRightTexture = defaultRight;
    
    self.moveLeftTextures = [self loadTexturesWithAtlasName:@"MoveLeft" andImagePrefix:@"move-left"];
    self.moveRightTextures = [self loadTexturesWithAtlasName:@"MoveRight" andImagePrefix:@"move-right"];
    self.jumpTextures = [self loadTexturesWithAtlasName:@"Jump" andImagePrefix:@"jump"];
    
    NSLog(@"%ld %ld %ld", self.moveLeftTextures.count, self.moveRightTextures.count, self.jumpTextures.count);
    NSLog(@"%ld", atlas.textureNames.count);
}

+(instancetype) characterWithPosition:(CGPoint)position andScale:(CGFloat)scale {
    return [[self alloc] initWithPosition:position andScale:scale];
}
@end
