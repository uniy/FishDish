//
//  MenuLayer.m
//  fishdish
//
//  Created by Uniy Xu on 12-8-23.
//  Copyright 2012年 xu_yunan@163.com. All rights reserved.
//

#import "MenuLayer.h"
#import "GameLayer.h"
#import "FishDishLayer.h"

@interface MenuLayer()
- (void)pause;
- (void)resume;
- (void)hiddenBackItem:(bool)isHidden;
- (void)toggleAction:(CCMenuItemToggle *)item;
@end

@implementation MenuLayer

- (id)init
{
    self = [super init];
    if (self) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCMenuItemFont *pauseItem = [CCMenuItemFont itemWithString:@"pause" target:self selector:@selector(pause)];
        pauseItem.tag = 1;
        CCMenuItemFont *resumeItem = [CCMenuItemFont itemWithString:@"resume" target:self selector:@selector(resume)];
        resumeItem.tag = 2;
        CCMenuItemToggle *pause = [CCMenuItemToggle itemWithTarget:self
                                                          selector:@selector(toggleAction:)
                                                             items:pauseItem, resumeItem, nil];
        pause.anchorPoint = ccp(0.5f, 0.0f);
        pause.position = ccp(winSize.width/2.0f, 30.0f);
        
        CCMenuItemFont *backItem = [CCMenuItemFont itemWithString:@"back" target:self selector:@selector(back)];
        backItem.tag = 3;
        backItem.anchorPoint = ccp(0.5f, 0.0f);
        backItem.position = ccp(winSize.width/2.0f, 0.0f);
        backItem.visible = NO;
        
        CCMenu *menu = [CCMenu menuWithItems:backItem, pause, nil];
        menu.tag = 4;
        menu.position = ccp(0, 0);
        [self addChild:menu];
    }
    return self;
}

- (void)pause
{
    [self hiddenBackItem:NO];
    [[CCDirector sharedDirector] pause];
}

- (void)resume
{
    [self hiddenBackItem:YES];
    [[CCDirector sharedDirector] resume];
}

- (void)hiddenBackItem:(bool)isHidden
{
    CCMenu *m = (CCMenu *)[self getChildByTag:4];
    CCMenuItem *menuItem = (CCMenuItem *)[m getChildByTag:3];
    menuItem.visible = !isHidden;
}

- (void)toggleAction:(CCMenuItemToggle *)item
{
    switch (item.selectedIndex) {
        case 0:
            [self resume];
            break;
        case 1:
            [self pause];
            break;
            
        default:
            break;
    }
}

- (void)back
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[FishDishLayer scene]];
}

/*
- (void)draw
{
    glLineWidth(2.0f);
    ccDrawColor4B(255.0f, 0.0f, 0.0f, 255.0f);
    ccDrawRect(ccp(0, 0), ccp(480, 60));
}
*/
@end
