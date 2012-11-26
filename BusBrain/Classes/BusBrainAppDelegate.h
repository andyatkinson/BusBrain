//
//  BusBrainAppDelegate.h
//  bus brain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright 2012, Beetle Fight. All rights reserved.
//

#import "MainTableViewController.h"
#define kAppName @"bus brain"
//#define DEBUG_BB 1;

@interface BusBrainAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
  IBOutlet UIWindow *window;
  MainTableViewController *mainTableViewController;
  UIViewController      *infoViewController;
  UIViewController      *infoTableViewController;
  UITabBarController    *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow     *window;
@property (nonatomic, retain) MainTableViewController *mainTableViewController;
@property (nonatomic, retain) UIViewController      *infoViewController;
@property (nonatomic, retain) UIViewController *infoTableViewController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

- (void) saveAnalytics:(NSString*) pageName;

@end

