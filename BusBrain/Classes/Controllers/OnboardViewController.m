//
//  OnboardViewController.m
//  BusBrain
//
//  Created by John Doll on 12/15/12.
//
//

#import "OnboardViewController.h"

@interface OnboardViewController ()

@end

@implementation OnboardViewController

- (void)dismiss:(UITapGestureRecognizer *)recognizer {
  [self dismissModalViewControllerAnimated:YES];
  
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  [settings setInteger:1 forKey:@"onboardingComplete"];
  [settings synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void) viewDidLoad {
  
  UIImage *bgImage;
  CGRect screenBounds = [[UIScreen mainScreen] bounds];
  if (screenBounds.size.height == 568) {
    bgImage = [UIImage imageNamed:@"onboard-568h@2x.png"];
  } else {
    bgImage = [UIImage imageNamed:@"onboard.png"];
  }
  UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
  
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;
  CGFloat screenHeight = screenRect.size.height;
  bgView.frame = CGRectMake(0, 0, screenWidth, screenHeight -20);
  
  UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(10, screenHeight - 91, screenWidth - 20, 60)];
  [startView setBackgroundColor:[UIColor clearColor]];
  
  UITapGestureRecognizer *singleFingerTap =
  [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(dismiss:)];
  [startView addGestureRecognizer:singleFingerTap];
  
  
  
  [self.view addSubview:bgView];
  [self.view addSubview:startView];
  
}


@end
