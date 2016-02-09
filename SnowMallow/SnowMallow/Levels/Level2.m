//
//  Level2.m
//  SnowMallow
//
//  Created by BaSk3T on 2/9/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "Level2.h"
#import "Level1.h"

@implementation Level2
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
    [self switchToNextLevel];
}

-(void)switchToNextLevel {
    Level1 *resetLevel = [[Level1 alloc] initWithSize:self.size];
    [self.view presentScene:resetLevel transition:[SKTransition fadeWithColor:[UIColor whiteColor] duration:2.0]];
    
    NSLog(@"another asd");
    SKLabelNode *winLabel = [SKLabelNode labelNodeWithText:@"You Won !"];
    winLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 100);
    winLabel.color = [UIColor blueColor];
    winLabel.xScale = 5;
    winLabel.yScale = 4;
    [self addChild:winLabel];
}

-(void)initializeLevel {
    [super initializeLevel];
    
    CGFloat halfWidth = CGRectGetMidX(self.frame);
    CGFloat halfHeight = CGRectGetMidY(self.frame);
    
    SKTexture *smallPlatformTexture = [SKTexture textureWithImageNamed:@"ground-small"];
    SKTexture *mediumPlatformTexture = [SKTexture textureWithImageNamed:@"ground-medium"];
    
    CGFloat firstLevelOfY = 80;
    CGFloat secondLevelOfY = firstLevelOfY + mediumPlatformTexture.size.height;
    CGFloat thirdLevelOfY = secondLevelOfY + mediumPlatformTexture.size.height * 3;
    
    Platform *rightMediumPlatform = [self createPlatformWithTextureNamed:nil orTexture:mediumPlatformTexture andPosition:CGPointMake(self.frame.size.width - mediumPlatformTexture.size.width, secondLevelOfY)];
    
    Platform *middleSmallPlatform = [self createPlatformWithTextureNamed:nil orTexture:smallPlatformTexture andPosition:CGPointMake(rightMediumPlatform.position.x - smallPlatformTexture.size.width, firstLevelOfY)];
    
    Platform *leftHighMediumPlatform = [self createPlatformWithTextureNamed:nil orTexture:mediumPlatformTexture andPosition:CGPointMake(0, thirdLevelOfY)];
    
    Platform *middleHighSmallPlatform = [self createPlatformWithTextureNamed:nil orTexture:smallPlatformTexture andPosition:CGPointMake(rightMediumPlatform.position.x - smallPlatformTexture.size.width, thirdLevelOfY)];
    
    self.character.position = CGPointMake(0 + leftHighMediumPlatform.size.width / 2, thirdLevelOfY + 30);
    
    NormalEnemy *enemy1 = [NormalEnemy normalEnemyWithPosition:CGPointMake(0 + leftHighMediumPlatform.size.width / 10, thirdLevelOfY + 30) direction:YES andScale:2.5];
    enemy1.physicsBody.collisionBitMask = self.platformCategory | self.levelCategory;
    enemy1.physicsBody.contactTestBitMask = self.levelCategory | self.enemyCategory;

    NormalEnemy *enemy2 = [NormalEnemy normalEnemyWithPosition:CGPointMake(0 + leftHighMediumPlatform.size.width, thirdLevelOfY + 30) direction:YES andScale:2.5];
    enemy2.physicsBody.collisionBitMask = self.platformCategory | self.levelCategory;
    enemy2.physicsBody.contactTestBitMask = self.snowBlastCategory | self.levelCategory | self.enemyCategory;

    NormalEnemy *enemy3 = [NormalEnemy normalEnemyWithPosition:CGPointMake(rightMediumPlatform.position.x + rightMediumPlatform.size.width / 2, thirdLevelOfY + 30) direction:YES andScale:2.5];
    enemy3.physicsBody.collisionBitMask = self.platformCategory | self.levelCategory;
    enemy3.physicsBody.contactTestBitMask = self.levelCategory | self.enemyCategory;
    

    [self addChild:middleSmallPlatform];
    [self addChild:rightMediumPlatform];
    [self addChild:leftHighMediumPlatform];
    [self addChild:enemy1];
    [self addChild:enemy2];
    [self addChild:enemy3];
}
@end
