//
//  HeroFish.h
//  fishdish
//
//  Created by Uniy Xu on 12-8-20.
//  Copyright 2012年 xu_yunan@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Fish.h"

@interface HeroFish : Fish {
        bool isSafe;
}
@property (nonatomic, assign) bool isSafe;

+ (id)spriteWithLevel:(FishLevel)l;
- (id)initWithLevel:(FishLevel)l;
- (void)die;
@end
