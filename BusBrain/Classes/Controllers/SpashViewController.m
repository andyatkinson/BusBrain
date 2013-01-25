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
  [_t invalidate];
  [self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void) progessSwirl:(NSTimer *)timer {
  _progressCounter++;
  
  if(_progressCounter == 100.0){
    _progressCounter = 0.0;
  }

  [[self hud] setProgress:_progressCounter / 100.0];
}

- (void) viewDidLoad {
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;
  CGFloat screenHeight = screenRect.size.height;
  _progressCounter = 0;
  
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
  
  float yPos = [self.view convertPoint:self.view.frame.origin toView:nil].y; //Should be 20
  if (screenBounds.size.height == 568) {
    // code for 4-inch screen
    [[self hud] setYOffset: ((yPos - 20) / 2) - 64.0];
    [[self hud] setXOffset:-0.5];
  } else {
    // code for 3.5-inch screen
    [[self hud] setYOffset:((yPos - 20) / 2)  - 58.0];
    [[self hud] setXOffset:-0.5];
  }
  
  [[self hud] setDimBackground:YES];
  
  _t = [NSTimer scheduledTimerWithTimeInterval:0.012
                                                target:self
                                              selector:@selector(progessSwirl:)
                                              userInfo:nil
                                               repeats:YES];
  
}

- (void) setProgress:(float) progress {
  
}


@end
