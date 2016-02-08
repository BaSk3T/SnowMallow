//
//  Level1.m
//  SnowMallow
//
//  Created by BaSk3T on 2/5/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "Level1.h"

@implementation Level1
- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        //self.physicsWorld.contactDelegate = self;
        SKTexture *mediumGround = [SKTexture textureWithImageNamed:@"ground-medium.png"];
        
        Platform *plat1 = [super createPlatformWithTextureNamed:@"ground" orTexture:nil andPosition:CGPointMake(0, 0)];
        Platform *platMid = [super createPlatformWithTextureNamed:nil orTexture:mediumGround andPosition:CGPointMake(CGRectGetMidX(self.frame) - mediumGround.size.width / 2, self.frame.size.height / 3)];
        Platform *plat2 = [super createPlatformWithTextureNamed:nil orTexture:mediumGround andPosition:CGPointMake(0, 300)];
        Platform *plat3 = [super createPlatformWithTextureNamed:nil orTexture:mediumGround andPosition:CGPointMake(370, 200)];
        
        NormalEnemy *normEnemy1 = [NormalEnemy normalEnemyWithPosition:CGPointMake(CGRectGetMidX(self.frame) - 100, 320) direction:NO andScale:2.5];
        normEnemy1.physicsBody.collisionBitMask = self.platformCategory | self.levelCategory;
        normEnemy1.physicsBody.contactTestBitMask = self.snowBlastCategory | self.levelCategory | self.enemyCategory;
        
        NormalEnemy *normEnemy2 = [NormalEnemy normalEnemyWithPosition:CGPointMake(CGRectGetMidX(self.frame) - 300, 320) direction:YES andScale:2.5];
        normEnemy2.physicsBody.collisionBitMask = self.platformCategory | self.levelCategory;
        normEnemy2.physicsBody.contactTestBitMask = self.snowBlastCategory | self.levelCategory | self.enemyCategory;
        
        [self addChild:plat1];
        [self addChild:platMid];
        [self addChild:plat2];
        [self addChild:plat3];
        [self addChild:normEnemy1];
        [self addChild:normEnemy2];
    }
    return self;
}
@end
