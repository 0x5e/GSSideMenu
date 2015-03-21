//
//  PanBehavior.m
//  GSSideMenu
//
//  Created by 0x5e on 15/3/18.
//  Copyright (c) 2015年 0x5e. All rights reserved.
//

#import "PanBehavior.h"

@implementation PanBehavior

#pragma mark - getter

- (UIGravityBehavior *)gravity {
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
    }
    return _gravity;
}

- (UICollisionBehavior *)collision {
    if (!_collision) {
        _collision = [[UICollisionBehavior alloc] init];
    }
    return _collision;
}

- (UIDynamicItemBehavior *)dynamicItem {
    if (!_dynamicItem) {
        _dynamicItem = [[UIDynamicItemBehavior alloc] init];
        _dynamicItem.allowsRotation = NO;
        _dynamicItem.elasticity = 0.35f;//弹性
        //_dynamicItem.friction = 0.2f;//摩擦系数
    }
    return _dynamicItem;
}

- (UIPushBehavior *)push {
    if (!_push) {
        _push = [[UIPushBehavior alloc] init];
        _push.magnitude = self.gravity.magnitude;
    }
    return _push;
}

#pragma mark -
#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addChildBehavior:self.gravity];
        [self addChildBehavior:self.collision];
        [self addChildBehavior:self.dynamicItem];
        [self addChildBehavior:self.push];
    }
    return self;
}

#pragma mark -
#pragma mark - Methods

- (void)addItem:(id<UIDynamicItem>)item {
    [self.childBehaviors makeObjectsPerformSelector:@selector(addItem:) withObject:item];
}

- (void)removeItem:(id<UIDynamicItem>)item {
    [self.childBehaviors makeObjectsPerformSelector:@selector(removeItem:) withObject:item];
}

@end
