//
//  MovableSpriteNode.h
//  SnowMallow
//
//  Created by BaSk3T on 2/7/16.
//  Copyright © 2016 BaSk3T. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MovableSpriteNode <NSObject>
-(NSMutableArray*) loadTexturesWithAtlasName:(NSString*) atlasName andImagePrefix:(NSString*) imagePrefix;
-(void) loadActionsForCharacter;
-(void) loadDefaultTextures;
@end
