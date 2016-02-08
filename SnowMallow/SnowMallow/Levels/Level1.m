//
//  Level1.m
//  SnowMallow
//
//  Created by BaSk3T on 2/5/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "Level1.h"
#import "BSJoystick.h"
#import "Character.h"
#import "Platform.h"
#import "NormalEnemy.h"
#import "SnowBlast.h"
#import "Snowball.h"
#import "Ender.h"

@interface Level1()
@property BSJoystick *joystick;
@property Character *character;
@property uint32_t platformCategory;
@property uint32_t characterCategory;
@property uint32_t enemyCategory;
@property uint32_t snowBlastCategory;
@property uint32_t enderCategory;
@property uint32_t snowballCategory;
@end

@implementation Level1

static const uint32_t levelCategory =  0x1 << 5;

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        self.platformCategory = [Platform getCategoryMask];
        self.characterCategory = [Character getCategoryMask];
        self.enemyCategory = [NormalEnemy getCategoryMask];
        self.snowBlastCategory = [SnowBlast getCategoryMask];
        self.enderCategory = [Ender getCategoryMask];
        self.snowballCategory = [Snowball getCategoryMask];
        
        self.backgroundColor = [UIColor blackColor];
        self.physicsWorld.contactDelegate = self;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = levelCategory;
        
        
        self.joystick = [BSJoystick joystickWithJoystickSize:80 stickSize:40 joystickColor:[UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.5] andStickColor:[UIColor redColor]];
        self.joystick.position = CGPointMake(self.frame.size.width / 9 - 50, self.frame.size.height / 4 - 50);
        self.joystick.zPosition = 10;
        
        self.character = [Character characterWithPosition:CGPointMake(self.frame.size.width / 2 - 120, 300 + 20) andScale:2];
        self.character.physicsBody.collisionBitMask = self.platformCategory | levelCategory | self.snowballCategory;
        self.character.physicsBody.contactTestBitMask = self.enemyCategory;
        self.character.zPosition = 1;
        
        SKTexture *mediumGround = [SKTexture textureWithImageNamed:@"ground-medium.png"];
        
        Platform *plat1 = [self createPlatformWithTextureNamed:@"ground" orTexture:nil andPosition:CGPointMake(0, 0)];
        Platform *platMid = [self createPlatformWithTextureNamed:nil orTexture:mediumGround andPosition:CGPointMake(CGRectGetMidX(self.frame) - mediumGround.size.width / 2, self.frame.size.height / 3)];
        Platform *plat2 = [self createPlatformWithTextureNamed:nil orTexture:mediumGround andPosition:CGPointMake(0, 300)];
        Platform *plat3 = [self createPlatformWithTextureNamed:nil orTexture:mediumGround andPosition:CGPointMake(370, 200)];
        
        NormalEnemy *normEnemy1 = [NormalEnemy normalEnemyWithPosition:CGPointMake(CGRectGetMidX(self.frame) - 100, 320) direction:NO andScale:2.5];
        normEnemy1.physicsBody.collisionBitMask = self.platformCategory | levelCategory;
        normEnemy1.physicsBody.contactTestBitMask = self.snowBlastCategory | levelCategory | self.enemyCategory;
        
        NormalEnemy *normEnemy2 = [NormalEnemy normalEnemyWithPosition:CGPointMake(CGRectGetMidX(self.frame) - 300, 320) direction:YES andScale:2.5];
        normEnemy2.physicsBody.collisionBitMask = self.platformCategory | levelCategory;
        normEnemy2.physicsBody.contactTestBitMask = self.snowBlastCategory | levelCategory | self.enemyCategory;
        
        CGFloat enderWidth = 5;
        CGFloat enderHeight = 50;
        
        Ender *leftEnd = [Ender enderWithPosition:CGPointMake(0, plat1.size.height) width:enderWidth andHeight:enderHeight];
        leftEnd.fillColor = [UIColor redColor];
        leftEnd.physicsBody.contactTestBitMask = self.enemyCategory;
        
        Ender *rightEnd = [Ender enderWithPosition:CGPointMake(self.frame.size.width - enderWidth, plat1.size.height) width:enderWidth andHeight:enderHeight];
        rightEnd.fillColor = [UIColor redColor];
        rightEnd.physicsBody.contactTestBitMask = self.enemyCategory;
        
        [self addChild:leftEnd];
        [self addChild:rightEnd];
        
        [self addChild:self.joystick];
        [self addChild:self.character];
        [self addChild:plat1];
        [self addChild:platMid];
        [self addChild:plat2];
        [self addChild:plat3];
        [self addChild:normEnemy1];
        [self addChild:normEnemy2];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    SnowBlast *snowBlast = [SnowBlast snowBlastWithPosition:CGPointMake(self.character.position.x, self.character.position.y) andPower:self.character.snowBlastPower];
    snowBlast.physicsBody.collisionBitMask = self.platformCategory | levelCategory | self.enemyCategory;
    snowBlast.physicsBody.contactTestBitMask = self.enemyCategory;
    
    [self.character throwSnowBlast];
    
    [self addChild:snowBlast];
    
    [snowBlast moveInDirection:self.character.isFacingLeft];
}

-(void)update:(NSTimeInterval)currentTime {
    
    if (self.joystick.x <= 0 - self.joystick.stickSize / 2) {
        self.character.isFacingLeft = YES;
        [self.character moveCharacterIfPossible];
    }
    else if (self.joystick.x >= 0 + self.joystick.stickSize / 2) {
        self.character.isFacingLeft = NO;
        [self.character moveCharacterIfPossible];
    }
    else {
        self.character.isMoving = NO;
    }
    
    if (!self.character.isMoving) {
        
        [self.character removeActionForKey:@"walk"];
        
        if (self.character.isFacingLeft) {
            self.character.texture = self.character.defaultLeftTexture;
        }
        else {
            self.character.texture = self.character.defaultRightTexture;
        }
    }
    
    if (!self.character.isJumping && self.joystick.y >= 0 + self.joystick.stickSize / 2) {
        [self.character jump];
    }

}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    if (contact.bodyB.categoryBitMask == self.enemyCategory
        && contact.bodyA.categoryBitMask == self.characterCategory) {
        NormalEnemy *enemy = (NormalEnemy*)contact.bodyB.node;
        
        Snowball *snowballOfEnemy = (Snowball*)[enemy childNodeWithName:@"snowball"];
        
        if (enemy.isFreezed && !enemy.isPushed && snowballOfEnemy.levelOfFreeze == 4) {
            enemy.isPushed = YES;
            [snowballOfEnemy removeAllActions];
            snowballOfEnemy.texture = snowballOfEnemy.fullTexture;
            self.character.physicsBody.collisionBitMask = self.platformCategory | levelCategory;
            [enemy rollSnowballInDirection: self.character.isFacingLeft];
        }
    }
    
    if (contact.bodyA.categoryBitMask == self.enderCategory
        && contact.bodyB.categoryBitMask == self.enemyCategory) {
        NormalEnemy *enemy = (NormalEnemy*)contact.bodyB.node;
        NSLog(@"snowball colided with ender");
        if (enemy.isFreezed) {
            self.character.physicsBody.collisionBitMask = self.platformCategory | levelCategory | self.snowballCategory;
            [enemy removeActionForKey:@"towardsWall"];
            [enemy wasDestroyed];
        }
    }
    
    if (contact.bodyA.categoryBitMask == self.enemyCategory
        && contact.bodyB.categoryBitMask == self.enemyCategory) {
        NormalEnemy *enemy = (NormalEnemy*)contact.bodyA.node;
        NormalEnemy *enemy2 = (NormalEnemy*)contact.bodyB.node;
        NSLog(@"snowball colided with enemy");
        
        if (!enemy.isFreezed && !enemy2.isFreezed) {
            return;
        }
        
        NormalEnemy *enemyNotFreezed = enemy.isFreezed ? enemy2 : enemy;
        NormalEnemy *otherEnemy = !enemy.isFreezed ? enemy2 : enemy;
        
        Snowball *snowballOfEnemy = (Snowball*)[enemyNotFreezed childNodeWithName:@"snowball"];

        if (!enemyNotFreezed.isFreezed && otherEnemy.isPushed) {
            [enemyNotFreezed wasDestroyed];
            return;
        }
        else if (snowballOfEnemy.levelOfFreeze != 4 && otherEnemy.isPushed) {
            [enemyNotFreezed wasDestroyed];
        }
        else {
            enemyNotFreezed.isPushed = YES;
            [snowballOfEnemy removeAllActions];
            snowballOfEnemy.texture = snowballOfEnemy.fullTexture;
            self.character.physicsBody.collisionBitMask = self.platformCategory | levelCategory;
            [enemyNotFreezed rollSnowballInDirection: self.character.isFacingLeft];
        }
    }
    
    if (contact.bodyA.categoryBitMask == levelCategory
        && contact.bodyB.categoryBitMask == self.enemyCategory) {
        NormalEnemy *enemy = (NormalEnemy*)contact.bodyB.node;
        NSLog(@"snowball colided with frame");
        
        if (enemy.isFreezed) {
            enemy.isFacingLeft = !enemy.isFacingLeft;
            [enemy removeActionForKey:@"towardsWall"];
            [enemy rollSnowballInDirection:enemy.isFacingLeft];
        }
        else {
            [enemy removeActionForKey:@"repeatedMoving"];
            enemy.isFacingLeft = !enemy.isFacingLeft;
            [enemy updateRepeatedMovingActions];
        }
        
    }
    
    if (contact.bodyB.categoryBitMask == self.snowBlastCategory
        && contact.bodyA.categoryBitMask == self.enemyCategory) {
        
        SnowBlast *snowBlast = (SnowBlast*)contact.bodyB.node;
        NormalEnemy *enemy = (NormalEnemy*)contact.bodyA.node;

        [enemy wasHit];
        [snowBlast runAction:snowBlast.animationExplodeAction completion:^{
            [snowBlast removeFromParent];
        }];
        
        Snowball *snowballOfEnemy = (Snowball*)[enemy childNodeWithName:@"snowball"];
       
        if (snowballOfEnemy) {
            if (snowballOfEnemy.levelOfFreeze == 4) {
                return;
            }
            
            [snowballOfEnemy updateLevelOfFreezeWithIncrease:YES];
        }
        else {
            Snowball *snowball = [Snowball snowballWithPosition:CGPointMake(0, 0) enemy:enemy andScale:1.3];
            [enemy addChild:snowball];
        }
    }
}

//-(void)didEndContact:(SKPhysicsContact *)contact {
//    NSLog(@"ENDED!");
//    self.character.isPushing = NO;
//}

-(Platform*) createPlatformWithTextureNamed:(NSString*) textureName orTexture:(SKTexture*) texture andPosition:(CGPoint) position {
    Platform *platform;
    
    if (texture) {
        platform = [Platform platformWithTexture:texture andPosition:position];
    }
    else {
        platform = [Platform platformWithTexture:[SKTexture textureWithImageNamed:textureName] andPosition:position];
    }
    
    platform.physicsBody.collisionBitMask = self.characterCategory | self.enemyCategory;
    
    return  platform;
}
@end
