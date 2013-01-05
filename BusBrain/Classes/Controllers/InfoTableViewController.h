//
//  InfoTableViewController.h
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface InfoTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate> {
  NSMutableArray *dataArrays;
  UITableView *tableView;
}

@property (nonatomic, strong) NSMutableArray *dataArrays;
@property (nonatomic, strong) UITableView *tableView;


@end
