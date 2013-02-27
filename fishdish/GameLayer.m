//
//  GameLayer.m
//  fishdish
//
//  Created by Uniy Xu on 12-8-15.
//  Copyright 2012年 xu_yunan@163.com. All rights reserved.
//

#import "GameLayer.h"
#import "HeroFish.h"
#import "EnemyFish.h"
#import "MenuLayer.h"

#define kFishEnemy_Max 20
#define kHeroFishSpeed 3
#define kNumberOfLifeMax 3

#define kScoreLabelTag 50
#define kLifeLabelTag 51
#define kAvoidFishPanelTag 52
#define kMenuLayerTag 100

#define FishLevel_1_MaxScore 100
#define FishLevel_2_MaxScore 200
#define FishLevel_3_MaxScore 400
#define FishLevel_4_MaxScore 800
#define FishLevel_5_MaxScore 1000
#define FishLevel_6_MaxScore 1200

@interface GameLayer()
- (void)setEnvironment;
- (void)setSprites;
- (void)setMenu;
- (void)setSomePanel;
- (void)addClam;
- (void)addStarFish;
- (void)addHeroFish:(FishLevel)level;
@end

@implementation GameLayer
@synthesize heroFish;
@synthesize fish_Enemys;
@synthesize score;
@synthesize numberOfLife;

+ (CCScene *)scene;
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        srandom(time(NULL));
        self.isTouchEnabled = YES;
        
        CCDirector *director = [CCDirector sharedDirector];
        winSize = director.winSize;
        
        CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"fish_baddie_parts.plist"];
        CCSpriteBatchNode *batch = [[CCSpriteBatchNode alloc] initWithFile:@"fish_baddie_parts.png" capacity:45];
        [self addChild:batch];
        [batch release];
        
        [frameCache addSpriteFramesWithFile:@"fish_background_parts.plist"];
        CCSpriteBatchNode *backgroundBatch = [[CCSpriteBatchNode alloc] initWithFile:@"fish_background_parts.png" capacity:26];
        [self addChild:backgroundBatch];
        [backgroundBatch release];
        
        [frameCache addSpriteFramesWithFile:@"fish_salmon_parts.plist"];
        CCSpriteBatchNode *HeroFishBatch = [[CCSpriteBatchNode alloc] initWithFile:@"fish_salmon_parts.png" capacity:42];
        [self addChild:HeroFishBatch];
        [HeroFishBatch release];
        
        [self setEnvironment];
        [self setSprites];
        [self setMenu];
        [self setSomePanel];
        
    }
    return self;
}

- (void)setEnvironment
{
    // 海洋
    CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"fishbackground.png"];
    background.anchorPoint = ccp(0.0f, 0.0f);
    background.scaleY = winSize.height/background.textureRect.size.height;
    [self addChild:background z:-1];
    
    // 泥土
    int number = CCRANDOM_0_1()*3;
    CCSprite *background_0 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"fishbackground_%d.png",number]];
    background_0.anchorPoint = ccp(0.0f, 0.0f);
    [self addChild:background_0];
    
    CCParticleSystem *bubbleParticle = [CCParticleSystemQuad particleWithFile:@"bubble_particle.plist"];
    [self addChild:bubbleParticle];
}

- (void)setSprites
{
    int clamCount = CCRANDOM_0_1()*3;       // 0, 1, 2
    for (int i=0; i<clamCount; i++) {
        [self addClam];
    }
    
    int starFishCount = CCRANDOM_0_1()*3;   // 0, 1, 2
    for (int i=0; i<starFishCount; i++) {
        [self addStarFish];
    }
    
    [self addHeroFish:FishLevel_0];
    
    fish_Enemys = [[NSMutableArray array] retain];
    [self schedule:@selector(addEnemyFish) interval:1.0f];
    [self schedule:@selector(updateHeroFishPostion:) interval:1.0f/120.0f];
}

- (void)setMenu
{
    MenuLayer *menuLayer = [MenuLayer node];
    self.anchorPoint = ccp(0.0f, 0.0f);
    menuLayer.position = ccp(0, winSize.height - 60.0f);
    menuLayer.tag = kMenuLayerTag;
    [self addChild:menuLayer z:1];
}

// score、avoid、life
- (void)setSomePanel
{
    CCSprite *scorePanel = [CCSprite spriteWithSpriteFrameName:@"score.png"];
    scorePanel.position = ccp(scorePanel.boundingBox.size.width/2, winSize.height - scorePanel.boundingBox.size.height/2);
    [self addChild:scorePanel z:1];
    
    
    CCSprite *avoidFishPanel = [CCSprite spriteWithSpriteFrameName:@"fish_avoid_0.png"];
    avoidFishPanel.anchorPoint = ccp(1.0f, 1.0f);
    avoidFishPanel.position = ccp(winSize.width + 20.0f, winSize.height);
    avoidFishPanel.tag = kAvoidFishPanelTag;
    [self addChild:avoidFishPanel z:1];
    
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:14];
    scoreLabel.position = ccp(scorePanel.position.x + 8, scorePanel.position.y + 2);
    [scoreLabel setAnchorPoint:ccp(0.0f, 0.0f)];
    [scoreLabel setColor:ccc3(246.0f, 69.0f, 202.0f)];
    [scoreLabel setHorizontalAlignment:kCCTextAlignmentLeft];
    [scoreLabel setTag:kScoreLabelTag];
    [self addChild:scoreLabel];
    
    numberOfLife = kNumberOfLifeMax;
    CCLabelTTF *lifeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",numberOfLife]
                                               fontName:@"Marker Felt"
                                               fontSize:14];
    lifeLabel.position = ccp(scorePanel.position.x - 10, scorePanel.position.y - 15);
    [lifeLabel setAnchorPoint:ccp(0.0f, 0.0f)];
    [lifeLabel setColor:ccc3(246.0f, 69.0f, 202.0f)];
    [lifeLabel setHorizontalAlignment:kCCTextAlignmentLeft];
    [lifeLabel setTag:kLifeLabelTag];
    [self addChild:lifeLabel];
}

- (void)addClam
{
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    CCSprite *clam = [CCSprite spriteWithSpriteFrameName:@"clam_0.png"];
    NSMutableArray *spriteFrames = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        NSString *frameName = [NSString stringWithFormat:@"clam_%d.png",i];
        [spriteFrames addObject:[frameCache spriteFrameByName:frameName]];
    }
    CCRepeatForever *clam_act = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:spriteFrames delay:CCRANDOM_0_1() + 0.5]]];
    float clam_x = CCRANDOM_0_1()*(winSize.width - clam.textureRect.size.width)+clam.textureRect.size.width/2;
    float clam_y = CCRANDOM_0_1()*15 + clam.textureRect.size.height/2;
    clam.position = ccp(clam_x, clam_y);
    [clam runAction:clam_act];
    [self addChild:clam z:0];
}

- (void)addStarFish
{
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    CCSprite *starFish = [CCSprite spriteWithSpriteFrameName:@"starfish_0.png"];
    NSMutableArray *spriteFrames = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        NSString *frameName = [NSString stringWithFormat:@"starfish_%d.png",i];
        [spriteFrames addObject:[frameCache spriteFrameByName:frameName]];
    }
    CCRepeatForever *starFish_act = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:spriteFrames delay:CCRANDOM_0_1() + 0.5]]];
    float starFish_x = CCRANDOM_0_1()*(winSize.width - starFish.textureRect.size.width)+starFish.textureRect.size.width/2;
    float starFish_y = CCRANDOM_0_1()*15 + starFish.textureRect.size.height/2;
    starFish.position = ccp(starFish_x, starFish_y);
    [starFish runAction:starFish_act];
    [self addChild:starFish z:0];
}

- (void)addEnemyFish
{
    if ([fish_Enemys count] >= kFishEnemy_Max) {
        return;
    }
    
    FishLevel level = -1;
    
    float randomValue = CCRANDOM_0_1();
    if (randomValue <= 0.5) {
        level = FishLevel__1;
    }else if (randomValue <= 0.6) {
        level = FishLevel_0;
    }else if (randomValue <= 0.7) {
        level = FishLevel_1;
    }else if (randomValue <= 0.8) {
        level = FishLevel_2;
    }else if (randomValue <= 0.9) {
        level = FishLevel_3;
    }else if (randomValue <= 0.94) {
        level = FishLevel_4;
    }else if (randomValue <= 0.98) {
        level = FishLevel_5;
    }else if (randomValue < 1.0) {
        level = FishLevel_6;
    }
    
    EnemyFish *fish = [EnemyFish spriteWithLevel:level];
    fish.gameLayer =self;
    fish.gameLayer = self;
    [fish move];
    [self addChild:fish];
    [fish_Enemys addObject:fish];
}

- (void)addHeroFish:(FishLevel)level
{
    heroFish = [HeroFish spriteWithLevel:level];
    heroFish.position = ccp(winSize.width/2.0f, winSize.height/2.0f);
    heroFish.gameLayer = self;
    [self addChild:heroFish z:1];
}

- (void)updateHeroFishPostion:(ccTime)time
{
    if (heroFish.isLive) {
        if ([self isReachThePoint:touchMovedLoc point:heroFish.position]) {
            return;
        }
        
        CGPoint sub = ccpSub(touchMovedLoc, heroFish.position);
        theta = ccpToAngle(sub);
        
        if (isDragging) {
            float sx = kHeroFishSpeed * cosf(theta);
            float sy = kHeroFishSpeed * sinf(theta);
            CGPoint nextPoint = ccpAdd(heroFish.position, ccp(sx, sy));
            heroFish.position = nextPoint;
        }
        
        if (heroFish.position.x < 0) {
            heroFish.position = ccp(0, heroFish.position.y);
        }else if (heroFish.position.y < 0) {
            heroFish.position = ccp(heroFish.position.x, 0);
        }else if (heroFish.position.x > winSize.width) {
            heroFish.position = ccp(winSize.width, heroFish.position.y);
        }else if (heroFish.position.y > winSize.height) {
            heroFish.position = ccp(heroFish.position.x, winSize.height);
        }
    }
}

#pragma mark -
#pragma mark CCStandardTouchDelegate

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint touchBeganLoc = [self convertTouchToNodeSpace:touch];
     */
}

float theta;
CGPoint touchMovedLoc;
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    touchMovedLoc = [self convertTouchToNodeSpace:touch];
     
    if (!isDragging) {
        isDragging = YES;
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isDragging = NO;
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    isDragging = NO;
}

- (bool)isReachThePoint:(CGPoint)p1 point:(CGPoint)p2
{
    CGRect rect = CGRectMake(p1.x - 2, p1.y - 2, 4, 4);
    return CGRectContainsPoint(rect, p2);
}

#pragma mark -
#pragma mark HeroFishAction

- (void)heroDead
{
    numberOfLife--;
    [(CCLabelTTF *)[self getChildByTag:kLifeLabelTag] setString:[NSString stringWithFormat:@"%d",numberOfLife]];
}

- (void)heroDeadActionFinished
{
    FishLevel fishLevel =  heroFish.level;
    [heroFish removeFromParentAndCleanup:YES];
    heroFish = nil;
    
    if (numberOfLife == 0) {
        self.isTouchEnabled = NO;
    }else {
        [self addHeroFish:fishLevel];
    }
}

#pragma mark -
#pragma mark EnemyFishAction

- (void)caculateScore:(int)s
{
    score += s;
    [(CCLabelTTF *)[self getChildByTag:kScoreLabelTag] setString:[NSString stringWithFormat:@"%d",score]];
    CCSprite *avoidFishPanel = (CCSprite *)[self getChildByTag:kAvoidFishPanelTag];
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    if (score >= FishLevel_6_MaxScore) {
        if (heroFish.level < FishLevel_6) {
            [heroFish setLevel:FishLevel_6];
            [avoidFishPanel setDisplayFrame:[frameCache spriteFrameByName:@"avoid_fish_type6_3.png"]];
            avoidFishPanel.scale = 0.4;
            return;
        }
    }else if (score >= FishLevel_5_MaxScore) {
        if (heroFish.level < FishLevel_5) {
            [heroFish setLevel:FishLevel_5];
            [avoidFishPanel setDisplayFrame:[frameCache spriteFrameByName:@"fish_avoid_5.png"]];
            return;
        }
    }else if (score >= FishLevel_4_MaxScore) {
        if (heroFish.level < FishLevel_4) {
            [heroFish setLevel:FishLevel_4];
            [avoidFishPanel setDisplayFrame:[frameCache spriteFrameByName:@"fish_avoid_4.png"]];
            return;
        }
    }else if (score >= FishLevel_3_MaxScore) {
        if (heroFish.level < FishLevel_3) {
            [heroFish setLevel:FishLevel_3];
            [avoidFishPanel setDisplayFrame:[frameCache spriteFrameByName:@"fish_avoid_3.png"]];
            return;
        }
    }else if (score >= FishLevel_2_MaxScore) {
        if (heroFish.level < FishLevel_2) {
            [heroFish setLevel:FishLevel_2];
            [avoidFishPanel setDisplayFrame:[frameCache spriteFrameByName:@"fish_avoid_2.png"]];
            return;
        }
    }else if (score >= FishLevel_1_MaxScore) {
        if (heroFish.level < FishLevel_1) {
            [heroFish setLevel:FishLevel_1];
            [avoidFishPanel setDisplayFrame:[frameCache spriteFrameByName:@"fish_avoid_1.png"]];
            return;
        }
    }
}

- (void)dealloc
{
    [super dealloc];
    [fish_Enemys release];
}

@end
