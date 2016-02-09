//
//  Level1.m
//  SnowMallow
//
//  Created by BaSk3T on 2/5/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "Level1.h"
#import "Level2.h"

@implementation Level1
- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        [self addStartButton];
    }
    return self;
}

- (void)prepareForNextLevel {
    [super prepareForNextLevel];
    NSLog(@"asd");
    [self switchToNextLevel];
}

-(void)switchToNextLevel {
    Level2 *nextLevel = [[Level2 alloc] initWithSize:self.size];
    [self.view presentScene:nextLevel transition:[SKTransition fadeWithColor:[UIColor whiteColor] duration:2.0]];
}

-(void)initializeLevel {
    [super initializeLevel];
    
    CGFloat halfWidth = CGRectGetMidX(self.frame);
    CGFloat halfHeight = CGRectGetMidY(self.frame);
    
    //        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"b-1.jpg"];
    //        background.position = CGPointMake(halfWidth, halfHeight + 17);
    //        background.blendMode = SKBlendModeReplace;
    //        background.xScale *= 1.3;
    
    SKTexture *smallPlatformTexture = [SKTexture textureWithImageNamed:@"ground-small"];
    SKTexture *mediumPlatformTexture = [SKTexture textureWithImageNamed:@"ground-medium"];
    
    CGFloat firstLevelOfY = 100;
    CGFloat secondLevelOfY = 180;
    CGFloat thirdLevelOfY = 265;
    
    Platform *leftLowerSmallPlatform = [self createPlatformWithTextureNamed:nil orTexture:smallPlatformTexture andPosition:CGPointMake(0, firstLevelOfY)];
    
    //        Platform *middleLowerSmallPlatform = [self createPlatformWithTextureNamed:nil orTexture:smallPlatformTexture andPosition:CGPointMake(halfWidth - smallPlatformTexture.size.width / 2 + 35, firstLevelOfY)];
    //
    //        middleLowerSmallPlatform.xScale *= 0.5;
    
    Platform *rightLowerSmallPlatform = [self createPlatformWithTextureNamed:nil orTexture:smallPlatformTexture andPosition:CGPointMake(self.frame.size.width - smallPlatformTexture.size.width, firstLevelOfY)];
    
    Platform *middleMiddleMediumPlatform = [self createPlatformWithTextureNamed:nil orTexture:mediumPlatformTexture andPosition:CGPointMake(halfWidth - mediumPlatformTexture.size.width / 2, secondLevelOfY)];
    
    Platform *leftHigherSmallPlatform = [self createPlatformWithTextureNamed:nil orTexture:smallPlatformTexture andPosition:CGPointMake(smallPlatformTexture.size.width / 4, thirdLevelOfY)];
    
    Platform *rightHigherSmallPlatform = [self createPlatformWithTextureNamed:nil orTexture:smallPlatformTexture andPosition:CGPointMake(self.size.width - smallPlatformTexture.size.width / 4 - smallPlatformTexture.size.width, thirdLevelOfY)];
    
    NormalEnemy *enemy1 = [NormalEnemy normalEnemyWithPosition:CGPointMake(middleMiddleMediumPlatform.frame.origin.x + middleMiddleMediumPlatform.frame.size.width / 2 + 60, secondLevelOfY + 30) direction:YES andScale:2.5];
    enemy1.physicsBody.collisionBitMask = self.platformCategory | self.levelCategory;
    enemy1.physicsBody.contactTestBitMask = self.levelCategory | self.enemyCategory;
    
    NormalEnemy *enemy2 = [NormalEnemy normalEnemyWithPosition:CGPointMake(rightHigherSmallPlatform.frame.origin.x, thirdLevelOfY + 30) direction:NO andScale:2.5];
    enemy2.physicsBody.collisionBitMask = self.platformCategory | self.levelCategory;
    enemy2.physicsBody.contactTestBitMask = self.snowBlastCategory | self.levelCategory | self.enemyCategory;
    
    NormalEnemy *enemy3 = [NormalEnemy normalEnemyWithPosition:CGPointMake(leftHigherSmallPlatform.frame.origin.x + smallPlatformTexture.size.width, thirdLevelOfY + 30) direction:YES andScale:2.5];
    enemy3.physicsBody.collisionBitMask = self.platformCategory | self.levelCategory;
    enemy3.physicsBody.contactTestBitMask = self.levelCategory | self.enemyCategory;
    
    //        [self addChild:background];
    [self addChild:leftLowerSmallPlatform];
    //        [self addChild:middleLowerSmallPlatform];
    [self addChild:rightLowerSmallPlatform];
    [self addChild:middleMiddleMediumPlatform];
    [self addChild:leftHigherSmallPlatform];
    [self addChild:rightHigherSmallPlatform];
    [self addChild:enemy1];
    [self addChild:enemy2];
    [self addChild:enemy3];
}
@end
