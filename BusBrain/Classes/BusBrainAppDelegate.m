//
//  BusBrainAppDelegate.m
//  bus brain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright Andy Atkinson 2009 http://webandy.com. All rights reserved.
//

#import "BusBrainAppDelegate.h"
#import "MainTableViewController.h"
#import "StopTimesTableViewController.h"
#import "InfoTableViewController.h"
#import "SpashViewController.h"

@implementation BusBrainAppDelegate

@synthesize window, mainTableViewController, infoViewController, infoTableViewController, tabBarController;

- (void) applicationWillEnterForeground:(UIApplication *)application {
  if([mainTableViewController isCacheStail]){
    [mainTableViewController initData:nil];
    [mainTableViewController initLocation];
  }
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {

  // Create image for navigation background - portrait
  UIImage *navigationBarImage = [UIImage imageNamed:@"bg_header.png"];
  [[UINavigationBar appearance] setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];

  [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
  tabBarController = [[UITabBarController alloc] init];
  
  mainTableViewController = [[MainTableViewController alloc] init];

  SpashViewController *splash = nil;
  if([mainTableViewController isCacheStail]){
    splash = [[SpashViewController alloc] init];
  }
  [mainTableViewController initData:splash];
  [mainTableViewController initLocation];
  
  
  UINavigationController *routesController = [[[UINavigationController alloc] initWithRootViewController:mainTableViewController] autorelease];
  routesController.navigationBar.barStyle = UIBarStyleDefault;
  routesController.tabBarItem.title = @"Departures";
  routesController.tabBarItem.image = [UIImage imageNamed:@"11-clock.png"];
  [mainTableViewController release];

  infoTableViewController = [[InfoTableViewController alloc] init];
  UINavigationController *infoController = [[[UINavigationController alloc] initWithRootViewController:infoTableViewController] autorelease];
  infoController.navigationBar.barStyle = UIBarStyleDefault;
  infoController.title = @"Info";
  infoController.tabBarItem.image = [UIImage imageNamed:@"90-lifebuoy.png"];
  [infoTableViewController release];

  tabBarController.viewControllers = [NSArray arrayWithObjects:routesController, infoController, nil];
  [window addSubview:tabBarController.view];

  if(splash != nil){
    [mainTableViewController presentModalViewController:splash animated:NO];
  }
  
  [window makeKeyAndVisible];
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