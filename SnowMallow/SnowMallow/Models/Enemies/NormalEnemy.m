//
//  NormalEnemy.m
//  SnowMallow
//
//  Created by BaSk3T on 2/6/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "NormalEnemy.h"
#import "Snowball.h"

@interface NormalEnemy()

@property NSArray *moveLeftTextures;
@property NSArray *moveRightTextures;
@property NSArray *rollLeftTextures;
@property NSArray *rollRightTextures;
@property NSArray *disappearTextures;
@property SKAction *combinedLeftActions;
@property SKAction *combinedRightActions;
@property SKAction *repeatCombinedMovingActions;
@end

@implementation NormalEnemy

static const uint32_t enemyCategory =  0x1 << 2;

-(instancetype)initWithPosition:(CGPoint)position direction:(BOOL) isFacingLeft andScale:(CGFloat)scale {
    self = [super init];
    
    if (self) {
        self.position = position;
        self.name = @"enemy";
        
        self.isFacingLeft = isFacingLeft;
        
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
        [self updateRepeatedMovingActions];
    }
    
    return self;
}

-(void) loadActionsForCharacter {
    self.animationMoveLeftAction = [SKAction animateWithTextures:self.moveLeftTextures timePerFrame:0.15];
    self.animationMoveRightAction = [SKAction animateWithTextures:self.moveRightTextures timePerFrame:0.15];
    self.animationRollLeftAction = [SKAction animateWithTextures:self.rollLeftTextures timePerFrame:0.15];
    self.animationRollRightAction = [SKAction animateWithTextures:self.rollRightTextures timePerFrame:0.15];
    self.animationDisappearAction = [SKAction animateWithTextures:self.disappearTextures timePerFrame:0.15];
    self.moveLeftAction = [SKAction moveByX:-self.size.width * 3 y:0 duration:3];
    self.moveRightAction = [SKAction moveByX:self.size.width * 3 y:0 duration:3];
    self.pushedLeftAction = [SKAction moveByX:-self.size.width y:0 duration:0.1];
    self.pushedRightAction = [SKAction moveByX:self.size.width y:0 duration:0.1];
    
    self.combinedLeftActions = [SKAction group:@[[SKAction repeatAction:self.animationMoveLeftAction count:10], self.moveLeftAction]];
    self.combinedRightActions = [SKAction group:@[[SKAction repeatAction:self.animationMoveRightAction count:10], self.moveRightAction]];
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
    self.rollRightTextures = [self loadTexturesWithAtlasName:@"NE-RollRight" andImagePrefix:@"roll-right"];
    self.disappearTextures = [self loadTexturesWithAtlasName:@"Disappear" andImagePrefix:@"disappear"];
}

-(void) wasHit {
    self.isFreezed = YES;
    SKAction *repeatRoll;
    
    [self removeActionForKey:@"repeatedMoving"];
    
    if (self.isFacingLeft) {
        repeatRoll = [SKAction repeatActionForever:self.animationRollLeftAction];
    }
    else {
        repeatRoll = [SKAction repeatActionForever:self.animationRollRightAction];
    }
    
    [self runAction:repeatRoll withKey:@"roll"];
}

-(void)rollSnowballInDirection:(BOOL)isFacingLeft {
    SKAction *repeatMove;
    self.isFacingLeft = isFacingLeft;
    
    if (isFacingLeft) {
        repeatMove = [SKAction repeatActionForever:self.pushedLeftAction];
    }
    else {
        repeatMove = [SKAction repeatActionForever:self.pushedRightAction];
    }
    
    [self runAction:repeatMove withKey:@"towardsWall"];
}

-(void) wasDestroyed {
    SKAction *rotate = [SKAction rotateToAngle:360 duration:(NSTimeInterval)0.45];
    SKAction *group = [SKAction group:@[rotate, self.animationDisappearAction]];
    
    [self removeAllChildren];
    
    [self runAction:group completion:^{
        [self removeAllActions];
        [self removeFromParent];
    }];
}

-(void) updateRepeatedMovingActions {
    if (self.isFacingLeft) {
        self.repeatCombinedMovingActions = [SKAction repeatActionForever:[SKAction sequence:@[self.combinedLeftActions, self.combinedRightActions]]];
    }
    else {
        self.repeatCombinedMovingActions = [SKAction repeatActionForever:[SKAction sequence:@[self.combinedRightActions, self.combinedLeftActions]]];
    }
    
    [self runAction:self.repeatCombinedMovingActions withKey:@"repeatedMoving"];
}

+(uint32_t)getCategoryMask {
    return enemyCategory;
}

+(instancetype)normalEnemyWithPosition:(CGPoint)position direction:(BOOL) isFacingLeft andScale:(CGFloat)scale {
    return [[self alloc] initWithPosition:position direction:isFacingLeft andScale:scale];
}
@end
