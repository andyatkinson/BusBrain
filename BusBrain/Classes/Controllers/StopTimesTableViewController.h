//
//  StopTimesTableViewController.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stop.h"
#import "Route.h"
#import "MBProgressHUD.h"
#import "BigDepartureTableViewCell.h"

@interface StopTimesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate> {
  UITableView *tableView;
  NSMutableArray *data;
  Route *selectedRoute;
  Stop *selectedStop;
  NSArray *stop_times;
  MBProgressHUD *HUD;
  BigDepartureTableViewCell *bigCell;
  NSTimer  *_refreshTimer;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) BigDepartureTableViewCell *bigCell;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSArray *stop_times;
@property (nonatomic, retain) Stop *selectedStop;
@property (nonatomic, retain) Route *selectedRoute;
@property (nonatomic, retain) NSTimer *refreshTimer;

- (void)loadStopTimes;

@end



