//
//  GSSideMenuViewController.m
//  GSSideMenu
//
//  Created by 0x5e on 15/3/18.
//  Copyright (c) 2015年 0x5e. All rights reserved.
//

#import "GSSideMenuViewController.h"
#import "PanBehavior.h"

@interface GSSideMenuViewController ()
@property (assign, nonatomic) BOOL viewHasAppeared;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) PanBehavior *panBehavior;
@property (assign, nonatomic) CGPoint panGestureOrigin;
@end

@implementation GSSideMenuViewController

#pragma mark - getter

- (CGFloat)menuWidth {
    if (!_menuWidth)
        _menuWidth = 200.0f;
    return _menuWidth;
}

- (BOOL)menuOpened {
    return self.centerView.frame.origin.x;//存在<1的偏差
}

- (UIView *)menuView {
    return  self.menuViewController.view;
}

- (UIView *)centerView {
    return self.centerViewController.view;
}

#pragma mark -
#pragma mark - UIDynamicAnimator

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

- (PanBehavior *)panBehavior {
    if (!_panBehavior) {
        _panBehavior = [[PanBehavior alloc] init];
        
        //设置边界
        [_panBehavior.collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, 0, 0, 1 - self.menuWidth)];
        
        __weak GSSideMenuViewController *weakself = self;
        _panBehavior.action = ^{
            [weakself setMenuViewPosition];
        };
        
        [self.animator addBehavior:_panBehavior];
    }
    return _panBehavior;
}

#pragma mark -
#pragma mark - setter

- (void)setMenuOpened:(BOOL)isOpened {
    self.panBehavior.gravity.gravityDirection = CGVectorMake(isOpened ? 5 : -5, 0);
}

#pragma mark -
#pragma mark - Initialization

+ (GSSideMenuViewController *)initWithCenterViewController:(UIViewController *)centerViewController MenuViewController:(UIViewController *)menuViewController {
    GSSideMenuViewController *controller = [GSSideMenuViewController new];
    controller.menuViewController = menuViewController;
    controller.centerViewController = centerViewController;
    return controller;
}

- (void)setupCenterView {
    self.centerView.frame = self.view.bounds;
    self.centerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.centerView];
    [self.panBehavior addItem:self.centerView];
}

- (void)setupMenuView {
    CGRect frame = self.view.bounds;
    frame.size.width = self.menuWidth;
    self.menuView.frame = frame;
    self.menuView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.view insertSubview:self.menuView atIndex:0];
    [self setMenuViewPosition];
}

- (void)drawShadows {
    self.centerView.layer.shadowOpacity = 0.75f;
    self.centerView.layer.shadowRadius = 10.0f;
}

#pragma mark -
#pragma mark - View Lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(!self.viewHasAppeared) {
        [self setupCenterView];
        [self setupMenuView];
        [self addGestureRecognizers];
        [self drawShadows];
        
        self.viewHasAppeared = YES;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.centerViewController) {
        if ([self.centerViewController isKindOfClass:[UINavigationController class]]) {
            return [((UINavigationController *)self.centerViewController).topViewController preferredStatusBarStyle];
        }
        return [self.centerViewController preferredStatusBarStyle];
    }
    return UIStatusBarStyleDefault;
}

#pragma mark -
#pragma mark - UIViewController Rotation

-(NSUInteger)supportedInterfaceOrientations {
    if (self.centerViewController) {
        if ([self.centerViewController isKindOfClass:[UINavigationController class]]) {
            return [((UINavigationController *)self.centerViewController).topViewController supportedInterfaceOrientations];
        }
        return [self.centerViewController supportedInterfaceOrientations];
    }
    return [super supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate {
    if (self.centerViewController) {
        if ([self.centerViewController isKindOfClass:[UINavigationController class]]) {
            return [((UINavigationController *)self.centerViewController).topViewController shouldAutorotate];
        }
        return [self.centerViewController shouldAutorotate];
    }
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (self.centerViewController) {
        if ([self.centerViewController isKindOfClass:[UINavigationController class]]) {
            return [((UINavigationController *)self.centerViewController).topViewController preferredInterfaceOrientationForPresentation];
        }
        return [self.centerViewController preferredInterfaceOrientationForPresentation];
    }
    return UIInterfaceOrientationPortrait;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.panBehavior removeItem:self.centerView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    [self.panBehavior addItem:self.centerView];
}

#pragma mark -
#pragma mark - UIGestureRecognizer Helpers

- (UIPanGestureRecognizer *)panGestureRecognizer {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handlePan:)];
    [recognizer setMaximumNumberOfTouches:1];
    [recognizer setDelegate:self];
    return recognizer;
}

- (UITapGestureRecognizer *)centerTapGestureRecognizer {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(centerViewControllerTapped:)];
    [tapRecognizer setDelegate:self];
    return tapRecognizer;
}

- (void)addGestureRecognizers {
    [self.view addGestureRecognizer:[self panGestureRecognizer]];
    [self.centerView addGestureRecognizer:[self centerTapGestureRecognizer]];
}

#pragma mark -
#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] &&
       self.menuOpened)
        return YES;
    
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
       [gestureRecognizer.view isEqual:self.view]) return YES;
    
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
        BOOL isHorizontalPanning = fabsf(velocity.x) > fabsf(velocity.y);
        return isHorizontalPanning;
    }
    return YES;
}

#pragma mark -
#pragma mark - UIGestureRecognizer Callbacks

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint gesturePoint = [gestureRecognizer locationInView:self.view];
    gesturePoint.y = self.centerView.center.y;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.panBehavior.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.centerView attachedToAnchor:self.centerView.center];
            [self.animator addBehavior:self.panBehavior.attachment];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint centerPoint = self.centerView.center;
            centerPoint.x += [gestureRecognizer locationInView:self.view].x - self.panGestureOrigin.x;
            
            //判断是否越界(不然会卡在边缘？)
            CGFloat xOrigin = centerPoint.x - self.view.center.x;
            if (xOrigin > 0 && xOrigin < self.menuWidth)
                [self.panBehavior.attachment setAnchorPoint:centerPoint];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            [self.animator removeBehavior:self.panBehavior.attachment];
            self.panBehavior.attachment = nil;
            
            //设置推力
            CGPoint velocity = [gestureRecognizer velocityInView:self.view];
            self.panBehavior.push.pushDirection = CGVectorMake(velocity.x / 5.0f, 0);
            [self.panBehavior.push setActive:YES];
            
            //设置运动方向
            CGFloat threshold = 20.0f;
            CGFloat xOffset = self.centerView.center.x - self.view.center.x;
            if (xOffset < threshold)
                [self setMenuOpened:NO];
            else if (xOffset > self.menuWidth - threshold)
                [self setMenuOpened:YES];
            else
                [self setMenuOpened:(velocity.x > 0)];
        }
            break;
        default:
            break;
    }
    self.panGestureOrigin = gesturePoint;
}

- (void)setMenuViewPosition {
    CGFloat motionFactor = 0.25f;
    CGRect frame = self.menuView.frame;
    frame.origin.x = motionFactor * (self.centerView.frame.origin.x - self.menuWidth);//视差效果
    self.menuView.frame = frame;
}

- (void)centerViewControllerTapped:(UITapGestureRecognizer *)recognizer {
    [self setMenuOpened:NO];
}
        
@end
