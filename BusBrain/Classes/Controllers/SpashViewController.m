//
//  SpashViewController.m
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "SpashViewController.h"
#import "BusLooknFeel.h"
#import "MBProgressHUD.h"

@implementation SpashViewController

@synthesize hud = _hud;

- (void) dismiss {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void) viewDidLoad {
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;
  CGFloat screenHeight = screenRect.size.height;
  
  UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
  
  CGRect screenBounds = [[UIScreen mainScreen] bounds];
  if (screenBounds.size.height == 568) {
    // code for 4-inch screen
    [bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_splash-568h.png"]]];
  } else {
    // code for 3.5-inch screen
    [bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_splash.png"]]];    
  }
  
  
  [self.view addSubview:bgView];
  
  [self setHud: [MBProgressHUD showHUDAddedTo:self.view animated:YES]];
  [[self hud] setMode: MBProgressHUDModeAnnularDeterminate];
  [[self hud] setOpacity:0];
  [[self hud] setLabelText: @""];
  
  if (screenBounds.size.height == 568) {
    // code for 4-inch screen
    [[self hud] setYOffset:-64.0];
    [[self hud] setXOffset:-0.5];
  } else {
    // code for 3.5-inch screen
    [[self hud] setYOffset:-58.0];
    [[self hud] setXOffset:-0.5];
  }
  
  
  
}

- (void) setProgress:(float) progress {
  [[self hud] setProgress:progress];
}

- (void) dealloc {
  [_hud dealloc];
  
  [super dealloc];
}

@end
