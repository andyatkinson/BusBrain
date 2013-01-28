//
//  BusBrainAppDelegate.m
//  bus brain
//
//  Copyright 2012, Beetle Fight. All rights reserved.
//

#import "BusBrainAppDelegate.h"
#import "OnboardViewController.h"
#import "MainTableViewController.h"
#import "StopTimesTableViewController.h"
#import "InfoTableViewController.h"
#import "SpashViewController.h"
#import "BusLooknFeel.h"
#import "DataCache.h"

#import "GAI.h"

static const NSInteger kGANDispatchPeriodSec = 10;
static NSString *const kTrackingId = @"UA-34997631-3";

@implementation BusBrainAppDelegate

@synthesize window, mainTableViewController, infoViewController, infoTableViewController, tabBarController;

- (NSString*) getDeviceName {
  NSArray *chunks = [[[UIDevice currentDevice] name] componentsSeparatedByString: @"'"];
  NSString *deviceName = [[NSString alloc] initWithString:[chunks objectAtIndex:0]];
  return deviceName;
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
  if([DataCache isCacheStail]){
    [mainTableViewController initData:nil];
    [mainTableViewController initLocation];
  }
  [self saveAnalytics:@"Entry"];
}

- (void) saveAnalytics:(NSString*) pageName {
  if([[self getDeviceName] isEqualToString:@"iPhone Simulator"]){
    NSLog([NSString stringWithFormat:@"Skip GA in Simulator: %@", pageName]);
    return;
  }
  
  [self.tracker trackView:pageName];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  // Initialize Google Analytics
  [GAI sharedInstance].debug = NO;
  [GAI sharedInstance].dispatchInterval = kGANDispatchPeriodSec;
  [GAI sharedInstance].trackUncaughtExceptions = YES;
  self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
  [self saveAnalytics:@"Entry"];
  
  // Create image for navigation background - portrait
  UIImage *navigationBarImage = [UIImage imageNamed:@"bg_header.png"];
  [[UINavigationBar appearance] setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];

  [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
  tabBarController = [[UITabBarController alloc] init];
  
  mainTableViewController = [[MainTableViewController alloc] init];

  OnboardViewController *onboard = nil;
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  int onboardingComplete = [settings integerForKey:@"onboardingComplete"];
  
  if(!onboardingComplete){
    onboard = [[OnboardViewController alloc] init];
  }
  
  
  SpashViewController *splash = nil;
  if(onboard == nil && [DataCache isCacheStail]){
    //splash = [[SpashViewController alloc] init];
  }
  [mainTableViewController initData:splash];
  [mainTableViewController initLocation];
  
  
  UINavigationController *routesController = [[UINavigationController alloc] initWithRootViewController:mainTableViewController];
  
  NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
  [titleBarAttributes setValue:[BusLooknFeel getNavigationTitleFont] forKey:UITextAttributeFont];
  [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
  
  routesController.navigationBar.barStyle = UIBarStyleDefault;
  routesController.tabBarItem.title = @"Departures";
  routesController.tabBarItem.image = [UIImage imageNamed:@"11-clock.png"];

  infoTableViewController = [[InfoTableViewController alloc] init];
  UINavigationController *infoController = [[UINavigationController alloc] initWithRootViewController:infoTableViewController];
  infoController.navigationBar.barStyle = UIBarStyleDefault;
  infoController.title = @"Info";
  infoController.tabBarItem.image = [UIImage imageNamed:@"icon_info.png"];

  tabBarController.viewControllers = [NSArray arrayWithObjects:routesController, infoController, nil];
  [window addSubview:tabBarController.view];
  [window makeKeyAndVisible];
  
  self.window.rootViewController = tabBarController;
  
  if(onboard == nil && [DataCache isCacheStail]){
    [mainTableViewController showHUD];
  }
  
  if(splash != nil){
    splash.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [mainTableViewController presentModalViewController:splash animated:NO];
  }
  if(onboard != nil){
    //splash.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [mainTableViewController presentModalViewController:onboard animated:NO];
  }
  
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[self mainTableViewController] purgeCachedData];
}



@end