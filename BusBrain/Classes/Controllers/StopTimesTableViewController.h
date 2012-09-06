//
//  StopTimesTableViewController.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusTable.h"
#import "Stop.h"
#import "Route.h"
#import "MBProgressHUD.h"
#import "BigDepartureTableViewCell.h"

@interface StopTimesTableViewController : BusTable <UITableViewDelegate, UITableViewDataSource> {
  NSMutableArray *_data;
  Route          *_selectedRoute;
  Stop           *_selectedStop;
  NSArray        *_stopTimes;  BigDepartureTableViewCell *_bigCell;
  NSTimer        *_refreshTimer;
}

@property (nonatomic, retain) BigDepartureTableViewCell *bigCell;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSArray *stopTimes;
@property (nonatomic, retain) Stop *selectedStop;
@property (nonatomic, retain) NSTimer *refreshTimer;

- (void)loadStopTimes;

@end



