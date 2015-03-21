//
//  MainViewController.m
//  GSSideMenu
//
//  Created by 0x5e on 15/3/18.
//  Copyright (c) 2015年 0x5e. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)awakeFromNib {
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuView"];
    self.centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CenterView"];
}

@end
