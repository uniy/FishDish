//
//  HeroFish.m
//  fishdish
//
//  Created by Uniy Xu on 12-8-20.
//  Copyright 2012年 xu_yunan@163.com. All rights reserved.
//

#import "HeroFish.h"

#define kSafeTimeOfHeroFish 6.0f

@implementation HeroFish
@synthesize isSafe;

// level: 0 ,1, 2, 3, 4, 5, 6
+ (id)spriteWithLevel:(FishLevel)l
{
    return [[[self alloc] initWithLevel:l] autorelease];
}

- (id)initWithLevel:(FishLevel)l
{
    self = [super initWithSpriteFrameName:[NSString stringWithFormat:@"fish_level%d_0.png",l]];
    if (self) {
        [self setLevel:l];
        [self initData];
        [self schedule:@selector(changeDirection)];
    }
    return self;
}

- (void)initData
{
    [super initData];
    isHero = YES;
    isLive = YES;
    [self setIsSafe:YES];
    direction = FishDirectionRight;
}

- (void)setIsSafe:(bool)safeStatus
{
    isSafe = safeStatus;
    if (isSafe) {
        self.opacity = 150;
        [self scheduleOnce:@selector(safeStatusFinished) delay:kSafeTimeOfHeroFish];
    }
}

- (void)safeStatusFinished
{
    self.opacity = 255;
    isSafe = NO;
}

- (void)setLevel:(FishLevel)l
{
    level = l;
    
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSMutableArray *spriteFrames = [NSMutableArray array];
    [self stopAllActions];
    
    for (int i=0; i<5; i++) {
        NSString *frameName = [NSString stringWithFormat:@"fish_level%d_%d.png", l, i];
        [spriteFrames addObject:[frameCache spriteFrameByName:frameName]];
    }
    
    CCRepeatForever *fish_act = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:spriteFrames delay:0.4]]];
    [self runAction:fish_act];
}

- (void)die
{
    [self stopAllActions];
    [gameLayer heroDead];
    
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSMutableArray *spriteFrames = [NSMutableArray array];
    
    for (int i=0; i<7; i++) {
        NSString *frameName = [NSString stringWithFormat:@"hero_fish_dead_%d.png",i];
        [spriteFrames addObject:[frameCache spriteFrameByName:frameName]];
    }
    
    id dead_act = [CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:spriteFrames delay:0.4]];
    CCRepeatForever *repeat_act = [CCRepeatForever actionWithAction:dead_act];
    [self runAction:repeat_act];
    
    id dead_goup_act = [CCMoveTo actionWithDuration:10.0f * (self.position.y / winSize.height) position:ccp(self.position.x, winSize.height + self.boundingBox.size.height)];
    CCSequence *actionSeq = [CCSequence actions:dead_goup_act, [CCCallFunc actionWithTarget:gameLayer
                                                                              selector:@selector(heroDeadActionFinished)], nil];
    [self runAction:actionSeq];
}

CGPoint preLoc;
- (void)changeDirection
{
    if (self.position.x > preLoc.x) {
        if (!self.flipX) {
            self.flipX = YES;
        }
    }else if (self.position.x < preLoc.x){
        if (self.flipX) {
            self.flipX = NO;
        }
    }
    preLoc = self.position;
}

@end
