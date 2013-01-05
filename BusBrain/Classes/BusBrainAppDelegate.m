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

#import "GANTracker.h"
static const NSInteger kGANDispatchPeriodSec = 10;

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
  [self saveAnalytics:@"/app_entry_point"];
}

- (void) saveAnalytics:(NSString*) pageName {
  
  if([[self getDeviceName] isEqualToString:@"iPhone Simulator"]){
    NSLog(@"Skip GA in Simulator");
    return;
  }
  
  [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-34997631-1"
                                         dispatchPeriod:kGANDispatchPeriodSec
                                               delegate:nil];
  
  NSError *error;
  
  if (![[GANTracker sharedTracker] trackPageview:pageName
                                       withError:&error]) {
    // Handle error here
  }
  
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  [self saveAnalytics:@"/app_entry_point"];
  
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
    [mainTableViewController setSurpressHUD:YES];
  }
  
  
  SpashViewController *splash = nil;
  if(onboard == nil && [DataCache isCacheStail]){
    splash = [[SpashViewController alloc] init];
    [mainTableViewController setSurpressHUD:YES];
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