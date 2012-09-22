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
  [bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]]];
  
   [self.view addSubview:bgView];
  
  [self setHud: [MBProgressHUD showHUDAddedTo:self.view animated:YES]];
  [[self hud] setMode: MBProgressHUDModeAnnularDeterminate];
  //[[self hud] setMode: MBProgressHUDModeDeterminate];
  [[self hud] setLabelText: @"Loading"];
  
}

- (void) setProgress:(float) progress {
  [[self hud] setProgress:progress];
}

- (void) dealloc {
  [_hud dealloc];
  
  [super dealloc];
}

@end
