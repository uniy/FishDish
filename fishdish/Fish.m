//
//  Fish.m
//  fishdish
//
//  Created by Uniy Xu on 12-8-15.
//  Copyright 2012年 xu_yunan@163.com. All rights reserved.
//

#import "Fish.h"

@interface Fish()
@end

@implementation Fish
@synthesize isHero;
@synthesize isLive;
@synthesize level;
@synthesize direction;
@synthesize gameLayer;

- (void)initData
{
    winSize = [CCDirector sharedDirector].winSize;
}

- (void)move
{
    
}

- (void)die
{
    self.visible = NO;
}

@end
