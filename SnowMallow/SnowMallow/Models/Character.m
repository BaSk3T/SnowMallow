//
//  Character.m
//  SnowMallow
//
//  Created by BaSk3T on 2/5/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "Character.h"
#import "SnowBlast.h"

@interface Character()
@property NSArray *moveLeftTextures;
@property NSArray *moveRightTextures;
@property NSArray *jumpLeftTextures;
@property NSArray *jumpRightTextures;
@property NSArray *pushLeftTextures;
@property NSArray *pushRightTextures;
@property NSArray *throwLeftTextures;
@property NSArray *throwRightTextures;
@end

@implementation Character

static const uint32_t characterCategory =  0x1 << 1;

-(instancetype) initWithPosition:(CGPoint)position andScale:(CGFloat) scale {
    self = [super init];
    
    if (self) {
        self.position = position;
        
        // Fill arrays with textures for given animation
        [self loadDefaultTextures];
        
        // Initiate default texture
        self.texture = self.defaultLeftTexture;
        self.size = CGSizeMake(self.texture.size.width, self.texture.size.height);
        
        self.snowBlastPower = @1;
        self.isAlive = YES;
        
        // Set size
        self.xScale = scale;
        self.yScale = scale;
        
        // Setting physics
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height - self.size.height / 10)];
        self.physicsBody.dynamic = YES;
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.categoryBitMask = characterCategory;
        
        // Load all actions
        [self loadActionsForCharacter];
    }
    
    return self;
}

-(void) loadActionsForCharacter {
    self.animationJumpLeftAction = [SKAction animateWithTextures:self.jumpLeftTextures timePerFrame:0.1];
    self.animationJumpRightAction = [SKAction animateWithTextures:self.jumpRightTextures timePerFrame:0.1];
    self.animationMoveLeftAction = [SKAction animateWithTextures:self.moveLeftTextures timePerFrame:0.1];
    self.animationMoveRightAction = [SKAction animateWithTextures:self.moveRightTextures timePerFrame:0.1];
    self.animationThrowLeftAction = [SKAction animateWithTextures:self.throwLeftTextures timePerFrame:0.1];
    self.animationThrowRightAction = [SKAction animateWithTextures:self.throwRightTextures timePerFrame:0.1];
    self.animationPushLeftAction = [SKAction animateWithTextures:self.pushLeftTextures timePerFrame:0.15];
    self.animationPushRightAction = [SKAction animateWithTextures:self.pushRightTextures timePerFrame:0.15];
    self.moveLeftAction = [SKAction moveByX:-self.size.width / 6 y:0 duration:0.1];
    self.moveRightAction = [SKAction moveByX:self.size.width / 6 y:0 duration:0.1];
    self.jumpAction = [SKAction moveByX:0 y:200 duration:0.5];
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
    self.jumpLeftTextures = [self loadTexturesWithAtlasName:@"JumpLeft" andImagePrefix:@"jump"];
    self.jumpRightTextures = [self loadTexturesWithAtlasName:@"JumpRight" andImagePrefix:@"jump"];
    self.throwLeftTextures = [self loadTexturesWithAtlasName:@"ThrowLeft" andImagePrefix:@"throw-left"];
    self.throwRightTextures = [self loadTexturesWithAtlasName:@"ThrowRight" andImagePrefix:@"throw-right"];
    self.pushLeftTextures = [self loadTexturesWithAtlasName:@"PushLeft" andImagePrefix:@"push-left"];
    self.pushRightTextures = [self loadTexturesWithAtlasName:@"PushRight" andImagePrefix:@"push-right"];
}

-(void) jump {
    self.isJumping = YES;
    
    if (self.isFacingLeft) {
        [self runAction:self.animationJumpLeftAction];
    }
    else {
        [self runAction:self.animationJumpRightAction];
    }
    
    [self runAction:self.jumpAction completion:^{
        self.isJumping = NO;
    }];
    
}

-(void) throwSnowBlast {
    if (self.isFacingLeft) {
        [self runAction:self.animationThrowLeftAction];
    }
    else {
        [self runAction:self.animationThrowRightAction];
    }
}

-(void) moveCharacterIfPossible {
    SKAction *repeatWalk;
    if (self.isFacingLeft) {
        repeatWalk = [SKAction repeatActionForever:self.animationMoveLeftAction];
        [self runAction:self.moveLeftAction];
    }
    else {
        repeatWalk = [SKAction repeatActionForever:self.animationMoveRightAction];
        [self runAction:self.moveRightAction];
    }
    
    if (!self.isMoving) {
        self.isMoving = YES;
        [self runAction:repeatWalk withKey:@"walk"];
    }
}

+(instancetype) characterWithPosition:(CGPoint)position andScale:(CGFloat)scale {
    return [[self alloc] initWithPosition:position andScale:scale];
}

+(uint32_t)getCategoryMask {
    return characterCategory;
}
@end
