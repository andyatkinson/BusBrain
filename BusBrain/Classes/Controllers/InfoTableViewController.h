//
//  InfoTableViewController.h
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MainTableViewController.h"
#import "MBProgressHUD.h"

@interface InfoTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, MBProgressHUDDelegate, BusProgressDelegate> {
  MBProgressHUD  *_hud;
  NSMutableArray *_dataArrays;
  UITableView    *_tableView;
}

@property (nonatomic, strong) MBProgressHUD  *hud;
@property (nonatomic, strong) NSMutableArray *dataArrays;
@property (nonatomic, strong) UITableView    *tableView;


@end
