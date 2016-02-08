//
//  Snowball.m
//  SnowMallow
//
//  Created by BaSk3T on 2/7/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "Snowball.h"

@interface Snowball()
@property NSArray *textures;
@property SKAction *fullyFrostedAction;
@property SKAction *halfFrostedAction;
@property NormalEnemy* enemy;
@end

@implementation Snowball

static const uint32_t snowballCategory =  0x1 << 6;

-(instancetype)initWithPosition:(CGPoint)position enemy:(NormalEnemy*)enemy andScale:(CGFloat)scale {
    self = [super init];
    
    if (self) {
        self.enemy = enemy;
        self.position = position;
        
        // Fill arrays with textures for given animation
        [self loadDefaultTextures];
        
        // Initiate state texture
        self.name = @"snowball";
        self.levelOfFreeze = 0;
        self.texture = self.textures[0];
        self.fullTexture = self.textures[3];
        self.size = CGSizeMake(self.texture.size.width, self.texture.size.height);
        
        self.physicsBody.categoryBitMask = snowballCategory;
        
        // Set size
        self.xScale = scale;
        self.yScale = scale;
        
        // Load all actions
        [self loadActionsForCharacter];
        
        [self updateLevelOfFreezeWithIncrease:YES];
    }
    
    return self;
}

-(void) loadActionsForCharacter {
    //self.animationAction = [SKAction]
    self.fullyFrostedAction = [SKAction waitForDuration:(NSTimeInterval)3];
    self.halfFrostedAction = [SKAction waitForDuration:(NSTimeInterval)0.5];
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
    
    self.textures = [self loadTexturesWithAtlasName:@"Snowball" andImagePrefix:@"snowball"];
}

-(void) updateLevelOfFreezeWithIncrease:(BOOL)increase {
    if (increase) {
        self.levelOfFreeze += 1;
    }
    else {
        self.levelOfFreeze -= 1;
    }
    
    NSLog(@"%d", self.levelOfFreeze);
    
    if (self.levelOfFreeze == 1) {
        self.texture = self.textures[0];
        [self runAction:self.halfFrostedAction completion:^{
            if (self.levelOfFreeze == 1) {
                self.enemy.isFreezed = NO;
                [self.enemy removeActionForKey:@"roll"];
                [self.enemy setTexture:self.enemy.defaultTexture];
                [self.enemy updateRepeatedMovingActions];
                [self removeFromParent];
            }
        }];
    }
    else if (self.levelOfFreeze == 2) {
        self.texture = self.textures[1];
        
        [self runAction:self.halfFrostedAction completion:^{
            if (self.levelOfFreeze == 2) {
                [self updateLevelOfFreezeWithIncrease:NO];
            }
        }];
    }
    else if (self.levelOfFreeze == 3) {
        self.texture = self.textures[2];
        
        [self runAction:self.halfFrostedAction completion:^{
            if (self.levelOfFreeze == 3) {
                [self updateLevelOfFreezeWithIncrease:NO];
            }
        }];
    }
    else if (self.levelOfFreeze == 4) {
        self.texture = self.textures[3];
        
        [self runAction:self.fullyFrostedAction completion:^{
            if (self.levelOfFreeze == 4) {
                [self updateLevelOfFreezeWithIncrease:NO];
            }
        }];
    }

}

+(uint32_t)getCategoryMask {
    return snowballCategory;
}

+(instancetype)snowballWithPosition:(CGPoint)position enemy:(NormalEnemy*)enemy andScale:(CGFloat)scale {
    return [[self alloc] initWithPosition:position enemy:enemy andScale:scale];
}

@end
