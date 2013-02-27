//
//  FishDishLayer.h
//  fishdish
//
//  Created by Uniy Xu on 12-8-14.
//  Copyright 2012年 xu_yunan@163.com. All rights reserved.
//  pictures from the website widgetworx.com

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    GameNormal,
    GameMedium,
    GameHard
} GameHardType;

@interface FishDishLayer : CCLayer {
    GameHardType gameHardSelected;
}
+ (CCScene *)scene;
@end
