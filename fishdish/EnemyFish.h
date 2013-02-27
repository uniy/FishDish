//
//  EnemyFish.h
//  fishdish
//
//  Created by Uniy Xu on 12-8-21.
//  Copyright 2012年 xu_yunan@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Fish.h"

@interface EnemyFish : Fish {
    
}
+ (id)spriteWithLevel:(FishLevel)l;
- (id)initWithLevel:(FishLevel)l;
@end
