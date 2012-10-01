//
//  BusBrainAppDelegate.m
//  bus brain
//
//  Copyright 2012, Beetle Fight. All rights reserved.
//

#import "BusBrainAppDelegate.h"
#import "MainTableViewController.h"
#import "StopTimesTableViewController.h"
#import "InfoTableViewController.h"
#import "SpashViewController.h"
#import "BusLooknFeel.h"

#import "GANTracker.h"
static const NSInteger kGANDispatchPeriodSec = 10;

@implementation BusBrainAppDelegate

@synthesize window, mainTableViewController, infoViewController, infoTableViewController, tabBarController;

- (void) applicationWillEnterForeground:(UIApplication *)application {
  if([mainTableViewController isCacheStail]){
    [mainTableViewController initData:nil];
    [mainTableViewController initLocation];
  }
  [self saveAnalytics:@"/app_entry_point"];
}

- (void) saveAnalytics:(NSString*) pageName {
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

  SpashViewController *splash = nil;
  if([mainTableViewController isCacheStail]){
    splash = [[SpashViewController alloc] init];
    [mainTableViewController setSurpressHUD:YES];
  }
  [mainTableViewController initData:splash];
  [mainTableViewController initLocation];
  
  
  UINavigationController *routesController = [[[UINavigationController alloc] initWithRootViewController:mainTableViewController] autorelease];
  
  NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
  [titleBarAttributes setValue:[BusLooknFeel getNavigationTitleFont] forKey:UITextAttributeFont];
  [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
  
  routesController.navigationBar.barStyle = UIBarStyleDefault;
  routesController.tabBarItem.title = @"Departures";
  routesController.tabBarItem.image = [UIImage imageNamed:@"11-clock.png"];
  [mainTableViewController release];

  infoTableViewController = [[InfoTableViewController alloc] init];
  UINavigationController *infoController = [[[UINavigationController alloc] initWithRootViewController:infoTableViewController] autorelease];
  infoController.navigationBar.barStyle = UIBarStyleDefault;
  infoController.title = @"Info";
  infoController.tabBarItem.image = [UIImage imageNamed:@"icon_info.png"];
  [infoTableViewController release];

  tabBarController.viewControllers = [NSArray arrayWithObjects:routesController, infoController, nil];
  [window addSubview:tabBarController.view];
  [window makeKeyAndVisible];
  
  self.window.rootViewController = tabBarController;
  if(splash != nil){
    [mainTableViewController presentModalViewController:splash animated:NO];
  }
  
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[self mainTableViewController] purgeCachedData];
}

- (void)dealloc {
  [mainTableViewController release];
  [infoViewController release];
  [tabBarController release];
  [window release];
  [super dealloc];
}


@end