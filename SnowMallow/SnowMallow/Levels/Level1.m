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

@interface Level1()
@property BSJoystick *joystick;
@property Character *character;
@property uint32_t platformCategory;
@property uint32_t characterCategory;
@property uint32_t enemyCategory;
@property uint32_t snowBlastCategory;
@property uint32_t snowballCategory;
@end

@implementation Level1
- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        self.platformCategory = [Platform getCategoryMask];
        self.characterCategory = [Character getCategoryMask];
        self.enemyCategory = [NormalEnemy getCategoryMask];
        self.snowBlastCategory = [SnowBlast getCategoryMask];
        self.snowballCategory = [Snowball getCategoryMask];
        
        self.backgroundColor = [UIColor blackColor];
        self.physicsWorld.contactDelegate = self;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        self.joystick = [BSJoystick joystickWithJoystickSize:80 stickSize:40 joystickColor:[UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.5] andStickColor:[UIColor redColor]];
        self.joystick.position = CGPointMake(self.frame.size.width / 9 - 50, self.frame.size.height / 4 - 50);
        self.joystick.zPosition = 10;
        
        self.character = [Character characterWithPosition:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) andScale:2];
        self.character.physicsBody.collisionBitMask = self.platformCategory | self.enemyCategory;
        self.character.zPosition = 1;
        
        SKTexture *mediumGround = [SKTexture textureWithImageNamed:@"ground-medium.png"];
        
        Platform *plat1 = [self createPlatformWithTextureNamed:@"ground" orTexture:nil andPosition:CGPointMake(0, 0)];
        Platform *platMid = [self createPlatformWithTextureNamed:nil orTexture:mediumGround andPosition:CGPointMake(CGRectGetMidX(self.frame) - mediumGround.size.width / 2, self.frame.size.height / 3)];
        
        NormalEnemy *normEnemy1 = [NormalEnemy normalEnemyWithPosition:CGPointMake(CGRectGetMidX(self.frame) + 50, CGRectGetMidY(self.frame)) andScale:2.5];
        normEnemy1.physicsBody.collisionBitMask = self.platformCategory | self.characterCategory;
        normEnemy1.physicsBody.contactTestBitMask = self.snowBlastCategory;
        
        [self addChild:self.joystick];
        [self addChild:self.character];
        [self addChild:plat1];
        [self addChild:platMid];
        [self addChild:normEnemy1];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SnowBlast *snowBlast = [SnowBlast snowBlastWithPosition:CGPointMake(self.character.position.x, self.character.position.y) andPower:self.character.snowBlastPower];
    snowBlast.physicsBody.collisionBitMask = self.enemyCategory | self.platformCategory;
    snowBlast.physicsBody.contactTestBitMask = self.enemyCategory;
    
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
    SnowBlast *snowBlast = (SnowBlast*)contact.bodyB.node;
    NormalEnemy *enemy = (NormalEnemy*)contact.bodyA.node;
    
    if (contact.bodyB.categoryBitMask == self.snowBlastCategory
        && contact.bodyA.categoryBitMask == self.enemyCategory) {
        
        [snowBlast runAction:snowBlast.animationExplodeAction completion:^{
            [snowBlast removeFromParent];
        }];
        
        SKAction *repeatRoll = [SKAction repeatActionForever:enemy.animationRollLeftAction];
        
        [enemy runAction: repeatRoll];
        
        Snowball *snowballOfEnemy = (Snowball*)[enemy childNodeWithName:@"snowball"];
       
        if (snowballOfEnemy) {
            if (snowballOfEnemy.levelOfFreeze == 4) {
                return;
            }
            
            [snowballOfEnemy updateLevelOfFreezeWithIncrease:YES];
        }
        else {
            Snowball *snowball = [Snowball snowballWithPosition:CGPointMake(0, 0) andScale:1.3];
            snowball.physicsBody.collisionBitMask = self.platformCategory | self.characterCategory;
            [enemy addChild:snowball];
        }
    }
    
}

-(Platform*) createPlatformWithTextureNamed:(NSString*) textureName orTexture:(SKTexture*) texture andPosition:(CGPoint) position {
    Platform *platform;
    
    if (texture) {
        platform = [Platform platformWithTexture:texture andPosition:position];
    }
    else {
        platform = [Platform platformWithTexture:[SKTexture textureWithImageNamed:textureName] andPosition:position];
    }
    
    platform.physicsBody.collisionBitMask = self.characterCategory;
    
    return  platform;
}
@end
