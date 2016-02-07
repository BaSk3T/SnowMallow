//
//  SnowBlast.m
//  SnowMallow
//
//  Created by BaSk3T on 2/7/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "SnowBlast.h"

@interface SnowBlast()
@property NSArray *moveTextures;
@property NSArray *explodeTextures;
@property NSNumber *power;
@property CGFloat distanceToMove;
@end

@implementation SnowBlast

static const uint32_t snowBlastCategory =  0x1 << 3;

-(instancetype)initWithPosition:(CGPoint)position andPower:(NSNumber*)power {
    self = [super init];
    
    if (self) {
        self.position = position;
        self.power = power;
        
        // Fill arrays with textures for given animation
        [self loadDefaultTextures];
        
        self.distanceToMove = self.size.width * 10;
        
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        // Setting physics
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
        self.physicsBody.dynamic = YES;
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.categoryBitMask = snowBlastCategory;
        self.physicsBody.affectedByGravity = NO;
        
        // Load all actions
        [self loadActionsForCharacter];

    }
    
    return self;
}

-(void) loadActionsForCharacter {
    self.animationMoveAction = [SKAction animateWithTextures:self.moveTextures timePerFrame:0.15];
    self.animationExplodeAction = [SKAction animateWithTextures:self.explodeTextures timePerFrame:0.1];
    self.moveLeftAction = [SKAction moveByX:-self.distanceToMove y:0 duration:0.75];
    self.moveRightAction = [SKAction moveByX:self.distanceToMove y:0 duration:0.75];
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
    
    if (self.power.intValue == 1) {
        self.moveTextures = [self loadTexturesWithAtlasName:@"SmallBlast" andImagePrefix:@"small-blast"];
        
        SKTexture *textureForSize = self.moveTextures[0];
        self.size = CGSizeMake(textureForSize.size.width, textureForSize.size.height);
        
        self.xScale += 3;
        self.yScale += 3;
    }
    else if (self.power.intValue == 2) {
        self.moveTextures = [self loadTexturesWithAtlasName:@"BigBlast" andImagePrefix:@"big-blast"];
        
        SKTexture *textureForSize = self.moveTextures[0];
        self.size = CGSizeMake(textureForSize.size.width, textureForSize.size.height);
        
        self.xScale += 1.5;
        self.yScale += 3;
    }
    
    self.explodeTextures = [self loadTexturesWithAtlasName:@"Explosion" andImagePrefix:@"explode"];
}

-(void)moveInDirection:(BOOL)isFacingLeft {
    SKAction *repeatMove = [SKAction repeatActionForever:self.animationMoveAction];
    [self runAction:repeatMove withKey:@"move"];
    
    if (isFacingLeft) {
        if (self.xScale < 0) {
            self.xScale *= -1;
        }
        [self runAction:self.moveLeftAction completion:^{
            [self removeActionForKey:@"move"];
            [self runAction:self.animationExplodeAction completion:^{
                [self removeFromParent];
            }];
        }];
        
    }
    else {
        if (self.xScale > 0) {
            self.xScale *= -1;
        }
        [self runAction:self.moveRightAction completion:^{
            [self removeActionForKey:@"move"];
            [self runAction:self.animationExplodeAction completion:^{
                [self removeFromParent];
            }];
        }];
    }
}

+(instancetype)snowBlastWithPosition:(CGPoint)position andPower:(NSNumber*)power {
    return [[self alloc] initWithPosition:position andPower:power];
}
@end
