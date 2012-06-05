//
//  BusBrainAppDelegate.h
//  bus brain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright 2009 Andy Atkinson http://webandy.com. All rights reserved.
//

#import "MainTableViewController.h"
#define kAppName @"Bus Brain"
//#define DEBUG_BB 1;

@interface BusBrainAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
  IBOutlet UIWindow *window;
  MainTableViewController *mainTableViewController;
  UIViewController      *infoViewController;
  UITableViewController *infoTableViewController;
  UITabBarController    *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow     *window;
@property (nonatomic, retain) MainTableViewController *mainTableViewController;
@property (nonatomic, retain) UIViewController      *infoViewController;
@property (nonatomic, retain) UITableViewController *infoTableViewController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;


@end

