//
//  FishDishLayer.m
//  fishdish
//
//  Created by Uniy Xu on 12-8-14.
//  Copyright 2012年 xu_yunan@163.com. All rights reserved.
//

#import "FishDishLayer.h"
#import "GameLayer.h"

#define kMenuTag 4

float enemyFishMoveDuration = 10;

@interface FishDishLayer(private)
- (void)setGameHardSelected:(GameHardType)type;
@end

@implementation FishDishLayer

+ (CCScene *)scene;
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	FishDishLayer *layer = [FishDishLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


// on "init" you need to initialize your instance
- (id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
      
    }
    
    return self;
}

- (void)onEnter
{
    [super onEnter];
    
    CCDirector *director = [CCDirector sharedDirector];
    CGSize winSize = director.winSize;
    
    CCSprite *background = [CCSprite spriteWithFile:@"menu_bg.png"];
    background.position = ccp(winSize.width/2.0f, winSize.height/2.0f);
    background.textureRect = CGRectMake(0.0f, 0.0f, 480.f, 320.f);
    [self addChild:background];
    
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"fish_title_parts.plist"];
    CCSpriteBatchNode *batch = [[CCSpriteBatchNode alloc] initWithFile:@"fish_title_parts.png" capacity:26];
    [self addChild:batch];
    [batch release];
    
    NSMutableArray *fishdish = [NSMutableArray array];
    for(int i = 0; i <3; i++) {
        [fishdish addObject:[frameCache spriteFrameByName:[NSString stringWithFormat:@"fish_dish_%d.png",i]]];
    }
    
    CCRepeatForever *fishdish_act = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:fishdish delay:0.6f]]];
    
    CCSprite *sprite;
    sprite = [CCSprite spriteWithSpriteFrameName:@"fish_dish_0.png"];
    sprite.position = ccp(winSize.width/2, winSize.height/2 + 120);
    [sprite runAction:fishdish_act];
    [self addChild:sprite];
    
    sprite = [CCSprite spriteWithSpriteFrameName:@"fish_bone.png"];
    sprite.position = ccp(winSize.width/2, winSize.height/2 + 10);
    [self addChild:sprite];
    
    CCMenuItemImage *normalItem = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"easy_not_mark.png"]
                                                          selectedSprite:[CCSprite spriteWithSpriteFrameName:@"esay_mark.png"]];
    normalItem.tag = 1;
    normalItem.anchorPoint = ccp(0.5, 0.5);
    normalItem.position = ccp(winSize.width/2 - 110, winSize.height/2 - 85);
    [normalItem setTarget:self selector:@selector(menuItemSelected:)];
    [normalItem selected];
    [self setGameHardSelected:GameNormal];
    
    CCMenuItemImage *mediumItem = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"medium_not_mark.png"]
                                                         selectedSprite:[CCSprite spriteWithSpriteFrameName:@"medium_mark.png"]];
    mediumItem.tag = 2;
    mediumItem.anchorPoint = ccp(0.5, 0.5);
    mediumItem.position = ccp(winSize.width/2, winSize.height/2 - 85);
    [mediumItem setTarget:self selector:@selector(menuItemSelected:)];
    
    CCMenuItemImage *hardItem = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"hard_not_mark.png"]
                                                         selectedSprite:[CCSprite spriteWithSpriteFrameName:@"hard_mark.png"]];
    hardItem.tag = 3;
    hardItem.anchorPoint = ccp(0.5, 0.5);
    hardItem.position = ccp(winSize.width/2 + 140, winSize.height/2 - 85);
    [hardItem setTarget:self selector:@selector(menuItemSelected:)];
    
    CCMenu *menu = [CCMenu menuWithItems:normalItem, mediumItem, hardItem, nil];
    menu.tag = kMenuTag;
    menu.position = ccp(0, 0);
    [self addChild:menu];
    
    CCMenuItemImage *startItem = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"start.png"]
                                                       selectedSprite:[CCSprite spriteWithSpriteFrameName:@"start_h.png"]];
    startItem.anchorPoint = ccp(0.5, 0.5);
    startItem.position = ccp(winSize.width/2, winSize.height/2 - 130);
    [startItem setTarget:self selector:@selector(startGame)];
    
    CCMenu *startMenu = [CCMenu menuWithItems:startItem, nil];
    startMenu.position = ccp(0, 0);
    [self addChild:startMenu];
}

- (void)menuItemSelected:(id)sender
{
    CCMenuItem *item = (CCMenuItem *)sender;
    CCMenuItem *otherItem;
    
    CCMenu *menu = (CCMenu *)[self getChildByTag:kMenuTag];
    CCArray *array = [menu children];
    
    for (int i=0; i<[array count]; i++) {
        otherItem = (CCMenuItem *)[array objectAtIndex:i];
        if (otherItem == item) {
            if(!item.isSelected) {
                [item selected];
                switch (item.tag) {
                    case 1:
                        [self setGameHardSelected:GameNormal];
                        break;
                    case 2:
                        [self setGameHardSelected:GameMedium];
                        break;
                    case 3:
                        [self setGameHardSelected:GameHard];
                        break;
                        
                    default:
                        break;
                }
            }
        }else {
            [otherItem unselected];
        }
    }
}

- (void)setGameHardSelected:(GameHardType)type
{
    gameHardSelected = type;
    
    switch (gameHardSelected) {
        case GameNormal:
            enemyFishMoveDuration = 10;
            break;
        case GameMedium:
            enemyFishMoveDuration = 7;
            break;
        case GameHard:
            enemyFishMoveDuration = 4;
            break;
        default:
            break;
    }
}

- (void)startGame
{
    [[CCDirector sharedDirector] replaceScene:[GameLayer scene]];
}

@end




