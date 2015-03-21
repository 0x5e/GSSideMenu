# GSSideMenu

A simple side menu using UIDynamics. Including gravity, attachment, push, parallax effect and so on.

Learned from [MFSideMenu](https://github.com/mikefrederick/MFSideMenu).

![preview](https://raw.githubusercontent.com/0x5e/GSSideMenu/master/preview.gif)

## Installation

#### CocoaPods
Add `pod 'GSSideMenu'` to your Podfile.

#### Manually
Add `GSSideMenu` folder to your project.

## Usage

### Basic Example

In your app delegate:

```objective-c
#import "GSSideMenu.h"

GSSideMenuViewController *container = [GSSideMenuViewController initWithCenterViewController:centerViewController MenuViewController:menuViewController;
self.window.rootViewController = container;
[self.window makeKeyAndVisible];
```

### Storyboard

1. Create a subclass of `GSSideMenu`, for example `MainViewController`.
2. Add two view controllers to your storyboard and give them identifiers, for example `@"MenuView"` and `@"CenterView"`.
3. Add a method `awakeFromNib` to `MainViewController` with the following code:

```objective-c
- (void)awakeFromNib {
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
    self.centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CenterView"];
}
```

