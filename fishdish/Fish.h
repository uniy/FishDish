//
//  Fish.h
//  fishdish
//
//  Created by Uniy Xu on 12-8-15.
//  Copyright 2012年 xu_yunan@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"

typedef enum {
    FishDirectionLeft,
    FishDirectionRight,
    FishDirectionTop,
    FishDirectionBottom
}FishDirection;

typedef enum {
    FishLevel__1 = -1,
    FishLevel_0 = 0,
    FishLevel_1 = 1,
    FishLevel_2 = 2,
    FishLevel_3 = 3,
    FishLevel_4 = 4,
    FishLevel_5 = 5,
    FishLevel_6 = 6
}FishLevel;

@interface Fish : CCSprite {
    bool isHero;
    bool isLive;
    FishLevel level;
    FishDirection direction;
    CGSize winSize;
    GameLayer *gameLayer;
}
@property (assign) bool isHero;
@property (assign) bool isLive;
@property (assign) FishLevel level;
@property (assign) FishDirection direction;
@property (nonatomic, assign) GameLayer *gameLayer;

- (void)initData;
- (void)move;
- (void)die;
@end
