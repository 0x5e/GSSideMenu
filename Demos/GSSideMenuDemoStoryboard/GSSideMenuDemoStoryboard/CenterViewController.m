//
//  CenterViewController.m
//  GSSideMenu
//
//  Created by 0x5e on 15/3/20.
//  Copyright (c) 2015年 0x5e. All rights reserved.
//

#import "CenterViewController.h"
#import "GSSideMenu.h"

@interface CenterViewController ()

@end

@implementation CenterViewController

- (IBAction)menu:(id)sender {
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    GSSideMenuViewController *controller = (GSSideMenuViewController *)window.rootViewController;
    [controller setMenuOpened:YES];
}

@end
