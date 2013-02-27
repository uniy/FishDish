//
//  EnemyFish.m
//  fishdish
//
//  Created by Uniy Xu on 12-8-21.
//  Copyright 2012年 xu_yunan@163.com. All rights reserved.
//

#import "EnemyFish.h"
#import "HeroFish.h"

extern float enemyFishMoveDuration;

#define FishLevel__1_Score 20
#define FishLevel_0_Score 40
#define FishLevel_1_Score 60
#define FishLevel_2_Score 80
#define FishLevel_3_Score 100
#define FishLevel_4_Score 120
#define FishLevel_5_Score 140

@interface EnemyFish()
- (int)fishScore:(FishLevel)l;
@end

@implementation EnemyFish

// level: -1 ,0 ,1, 2, 3, 4, 5, 6 = shark
+ (id)spriteWithLevel:(FishLevel)l
{
    return [[[self alloc] initWithLevel:l] autorelease];
}

- (id)initWithLevel:(FishLevel)l
{
    self = [super initWithSpriteFrameName:[NSString stringWithFormat:@"avoid_fish_type%d_0.png",l]];
    if (self) {
        [self setLevel:l];
        [self initData];
    }
    return self;
}

- (void)initData
{
    [super initData];
    isHero = NO;
    isLive = YES;
    srandom(time(NULL));
    [self scheduleUpdate];
}

- (void)setLevel:(FishLevel)l
{
    level = l;
    
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSMutableArray *spriteFrames = [NSMutableArray array];
    
    int frameCount;
    if (l == -1) {
        frameCount = 3;
    }else if (l == 6) {
        frameCount = 4;
    }else {
        frameCount = 5;
    }
    
    for (int i=0; i<frameCount; i++) {
        NSString *frameName = [NSString stringWithFormat:@"avoid_fish_type%d_%d.png", l, i];
        [spriteFrames addObject:[frameCache spriteFrameByName:frameName]];
    }
    
    CCRepeatForever *fish_act = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:spriteFrames delay:0.4]]];
    [self runAction:fish_act];
}

- (void)move
{
    int value = CCRANDOM_0_1() * 2;     // 0, 1
    CCBezierTo *bezierto = (CCBezierTo *)[self moveFromLeft];
    switch (value) {
        case 0:
            bezierto = (CCBezierTo *)[self moveFromLeft];
            break;
        case 1:
            bezierto = (CCBezierTo *)[self moveFromRight];
            break;
        default:
            break;
    }
    
    CCSequence *sequence;
    if (bezierto) {
        sequence = [CCSequence actions:bezierto, [CCCallFunc actionWithTarget:self selector:@selector(moveFinish)], nil];
    }else {
        sequence = [CCSequence actions:[CCCallFunc actionWithTarget:self selector:@selector(moveFinish)], nil];
    }
    [self runAction:sequence];
}

- (CCAction *)moveFromLeft
{
    self.flipX = YES;
    int start_x = -self.textureRect.size.width/2.0f;
    int start_y = CCRANDOM_0_1()*winSize.height;
    int end_x = winSize.width + self.textureRect.size.width/2.0f;
    int end_y = CCRANDOM_0_1()*winSize.height;
    
    return [self moveWithCurve:ccp(start_x, start_y) endPoint:ccp(end_x, end_y)];
}

- (CCAction *)moveFromRight
{
    self.flipX = NO;
    int end_x = -self.textureRect.size.width/2.0f;
    int end_y = CCRANDOM_0_1()*winSize.height;
    int start_x = winSize.width + self.textureRect.size.width/2.0f;
    int start_y = CCRANDOM_0_1()*winSize.height;
    
    return [self moveWithCurve:ccp(start_x, start_y) endPoint:ccp(end_x, end_y)];
}

- (CCAction *)moveWithCurve:(CGPoint)start endPoint:(CGPoint)end
{
    self.position = start;
    CGPoint ctrlPoint_1;
    CGPoint ctrlPoint_2;
    
    ctrlPoint_1 = ccp(CCRANDOM_0_1()*winSize.width, CCRANDOM_0_1()*winSize.height);
    ctrlPoint_2 = ccp(CCRANDOM_0_1()*winSize.width, CCRANDOM_0_1()*winSize.height);
    ccBezierConfig bezier;
    bezier.controlPoint_1 = ctrlPoint_1;
    bezier.controlPoint_2 = ctrlPoint_2;
    bezier.endPosition = end;
    CCBezierTo *bezierto = [CCBezierTo actionWithDuration:enemyFishMoveDuration bezier:bezier];
    return bezierto;
}

- (void)moveFinish
{
    isLive = NO;
}

- (void)update:(ccTime)delta
{
    if (!self.isLive) {
        [self die];
    }
}

- (bool)isLive
{
    HeroFish *hero = gameLayer.heroFish;
    bool isCantain = CGRectIntersectsRect(self.boundingBox, hero.boundingBox);
    if (hero && isCantain) {
        if (hero.level > self.level) {
            isLive = NO;
            [gameLayer caculateScore:[self fishScore:self.level]];
        }else {
            if (!hero.isSafe && hero.isLive) {
                hero.isLive = NO;
                [hero die];
            } 
        }
    }
    return isLive;
}

- (int)fishScore:(FishLevel)l
{
    switch (level) {
        case FishLevel__1:
            return FishLevel__1_Score;
            break;
        case FishLevel_0:
            return FishLevel_0_Score;
            break;
        case FishLevel_1:
            return FishLevel_1_Score;
            break;
        case FishLevel_2:
            return FishLevel_2_Score;
            break;
        case FishLevel_3:
            return FishLevel_3_Score;
            break;
        case FishLevel_4:
            return FishLevel_4_Score;
            break;
        case FishLevel_5:
            return FishLevel_5_Score;
            break;
        default:
            
            break;
    }
    return 0;
}

- (void)die
{
    [super die];
    if (gameLayer) {
        [gameLayer.fish_Enemys removeObject:self];
    }
    [self stopAllActions];
    [self removeFromParentAndCleanup:YES];
}

@end
