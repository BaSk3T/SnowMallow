//
//  Level.m
//  SnowMallow
//
//  Created by BaSk3T on 2/8/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import "Level.h"

@implementation Level

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
        self.levelCategory = levelCategory;
        
        self.backgroundColor = [UIColor blackColor];
        self.physicsWorld.contactDelegate = self;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = levelCategory;
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.character.isAlive) {
        SnowBlast *snowBlast = [SnowBlast snowBlastWithPosition:CGPointMake(self.character.position.x, self.character.position.y) andPower:self.character.snowBlastPower];
        snowBlast.physicsBody.collisionBitMask = levelCategory | self.enemyCategory;
        snowBlast.physicsBody.contactTestBitMask = self.enemyCategory;
        
        [self.character throwSnowBlast];
        
        [self addChild:snowBlast];
        
        [snowBlast moveInDirection:self.character.isFacingLeft];
    }
    
    if ([self childNodeWithName:@"start-game-button"]) {
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            SKNode *node = [self nodeAtPoint:location];
            
            if ([node.name isEqualToString:@"start-game-button"]) {
                [node removeFromParent];
                [self initializeLevel];
            }
        }
    }
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
    
    if (contact.bodyB.categoryBitMask == self.enemyCategory && contact.bodyA.categoryBitMask == self.characterCategory) {
        NormalEnemy *enemy = (NormalEnemy*)contact.bodyB.node;
        [self checkCollisionBetweenCharacterAndEnemy:enemy];
    }
    else if (contact.bodyB.categoryBitMask == self.characterCategory && contact.bodyA.categoryBitMask == self.enemyCategory) {
        NormalEnemy *enemy = (NormalEnemy*)contact.bodyA.node;
        [self checkCollisionBetweenCharacterAndEnemy:enemy];
    }
    
    if (contact.bodyA.categoryBitMask == self.enderCategory
        && contact.bodyB.categoryBitMask == self.enemyCategory) {
        NormalEnemy *enemy = (NormalEnemy*)contact.bodyB.node;
        NSLog(@"snowball colided with ender");
        if (enemy.isFreezed) {
            self.character.physicsBody.collisionBitMask = self.platformCategory | levelCategory | self.snowballCategory;
            [enemy removeActionForKey:@"towardsWall"];
            [enemy wasDestroyed];
            
            [self runAction:[SKAction waitForDuration:(NSTimeInterval)1] completion:^{
                if (![self childNodeWithName:@"enemy"]) {
                    [self prepareForNextLevel];
                }
            }];
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
        
        [self checkForCollisionBetweenSnowBlast:snowBlast andEnemy:enemy];
    }
    else if (contact.bodyA.categoryBitMask == self.snowBlastCategory
             && contact.bodyB.categoryBitMask == self.enemyCategory) {
        
        SnowBlast *snowBlast = (SnowBlast*)contact.bodyA.node;
        NormalEnemy *enemy = (NormalEnemy*)contact.bodyB.node;
        
        [self checkForCollisionBetweenSnowBlast:snowBlast andEnemy:enemy];
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
    
    platform.physicsBody.collisionBitMask = self.characterCategory | self.enemyCategory;
    
    return  platform;
}


-(void) initializeLevel {
    self.joystick = [BSJoystick joystickWithJoystickSize:80 stickSize:40 joystickColor:[UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.5] andStickColor:[UIColor redColor]];
    self.joystick.position = CGPointMake(self.frame.size.width / 9 - 50, self.frame.size.height / 4 - 50);
    self.joystick.zPosition = 10;
    
    Platform *basePlat = [self createPlatformWithTextureNamed:@"ground" orTexture:nil andPosition:CGPointMake(0, 0)];
    
    self.character = [Character characterWithPosition:CGPointMake(self.frame.size.width / 2, basePlat.size.height + 10) andScale:2];
    self.character.physicsBody.collisionBitMask = self.platformCategory | levelCategory | self.snowballCategory;
    self.character.physicsBody.contactTestBitMask = self.enemyCategory;
    self.character.zPosition = 3;
    
    CGFloat enderWidth = 5;
    CGFloat enderHeight = 50;
    
    Ender *leftEnd = [Ender enderWithPosition:CGPointMake(0, basePlat.size.height) width:enderWidth andHeight:enderHeight];
    //leftEnd.fillColor = [UIColor redColor];
    leftEnd.physicsBody.contactTestBitMask = self.enemyCategory;
    
    Ender *rightEnd = [Ender enderWithPosition:CGPointMake(self.frame.size.width - enderWidth, basePlat.size.height) width:enderWidth andHeight:enderHeight];
    //rightEnd.fillColor = [UIColor redColor];
    rightEnd.physicsBody.contactTestBitMask = self.enemyCategory;
    
    [self addChild:leftEnd];
    [self addChild:rightEnd];
    
    [self addChild:self.joystick];
    [self addChild:self.character];
    [self addChild:basePlat];
}

- (void) prepareForNextLevel {
    [self removeEverythingFromParent];
    [self removeFromParent];
}

- (void) removeEverythingFromParent {
    [self removeAllChildren];
    [self removeAllActions];
}

- (void) checkCollisionBetweenCharacterAndEnemy:(NormalEnemy*)enemy {
    Snowball *snowballOfEnemy = (Snowball*)[enemy childNodeWithName:@"snowball"];
    
    if (enemy.isFreezed && !enemy.isPushed && snowballOfEnemy.levelOfFreeze == 4) {
        enemy.isPushed = YES;
        [snowballOfEnemy removeAllActions];
        snowballOfEnemy.texture = snowballOfEnemy.fullTexture;
        self.character.physicsBody.collisionBitMask = self.platformCategory | levelCategory;
        [enemy rollSnowballInDirection: self.character.isFacingLeft];
    }
    
    if (!enemy.isFreezed && !enemy.isPushed) {
        self.character.isAlive = NO;
        [self.character runAction:self.character.animationDestroyedAction completion:^{
            [self removeEverythingFromParent];
            [self addStartButton];
        }];
    }
}

- (void) checkForCollisionBetweenSnowBlast:(SnowBlast*)snowBlast andEnemy:(NormalEnemy*)enemy {
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

- (void) addStartButton {
    SKSpriteNode *button = [SKSpriteNode spriteNodeWithImageNamed:@"start-button.png"];
    button.name = @"start-game-button";
    button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    button.zPosition = 10;
    
    [self addChild:button];
}
@end
