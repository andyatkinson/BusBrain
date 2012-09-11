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
  UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
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
