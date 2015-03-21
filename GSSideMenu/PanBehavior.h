//
//  PanBehavior.h
//  GSSideMenu
//
//  Created by 0x5e on 15/3/18.
//  Copyright (c) 2015年 0x5e. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanBehavior : UIDynamicBehavior

@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong, nonatomic) UIDynamicItemBehavior *dynamicItem;
@property (strong, nonatomic) UIPushBehavior *push;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;

- (void)addItem:(id <UIDynamicItem>)item;
- (void)removeItem:(id <UIDynamicItem>)item;

@end
