//
//  GSSideMenuViewController.h
//  GSSideMenu
//
//  Created by 0x5e on 15/3/18.
//  Copyright (c) 2015年 0x5e. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSSideMenuViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIViewController *menuViewController;
@property (strong, nonatomic) UIViewController *centerViewController;

@property (assign, nonatomic) CGFloat menuWidth;
@property (assign, nonatomic) BOOL menuOpened;

+ (GSSideMenuViewController *)initWithCenterViewController:(UIViewController *)centerViewController MenuViewController:(UIViewController *)menuViewController;

@end
