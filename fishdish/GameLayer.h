//
//  GameLayer.h
//  fishdish
//
//  Created by Uniy Xu on 12-8-15.
//  Copyright 2012年 xu_yunan@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class HeroFish;

@interface GameLayer : CCLayer {
    CGSize winSize;
    HeroFish *heroFish;
    NSMutableArray *fish_Enemys;
    
    bool isDragging;
    int score;
    int numberOfLife;
}
@property (nonatomic, assign) HeroFish *heroFish;
@property (nonatomic, retain) NSMutableArray *fish_Enemys;
@property (assign) int score;
@property (assign) int numberOfLife;
+ (CCScene *)scene;
- (void)heroDead;
- (void)heroDeadActionFinished;
- (void)caculateScore:(int)s;
@end
