//
//  SpashViewController.h
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewController.h"
#import "MBProgressHUD.h"

@interface SpashViewController : UIViewController <BusProgressDelegate>  {
  MBProgressHUD *_hud;
  float           _progressCounter;
  NSTimer       *_t;
}

@property (nonatomic, strong) MBProgressHUD *hud;

- (void) setProgress:(float) progress;
- (void) dismiss;

@end
