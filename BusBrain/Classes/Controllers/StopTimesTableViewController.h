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
#import "CountDownCell.h"
#import "MainTableViewController.h"

@interface StopTimesTableViewController : BusTable <UITableViewDelegate, UITableViewDataSource> {
  Route               *_selectedRoute;
  Stop                *_selectedStop;
  NSArray             *_stopTimes;
  CountDownCell       *_countDownCell;
  NSMutableArray      *_stopHours;
  NSMutableDictionary *_stopData;
  
  NSTimer             *_refreshTimer;
}

@property (nonatomic, strong) CountDownCell *countDownCell;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSArray *stopTimes;
@property (nonatomic, strong) NSMutableArray *stopHours;
@property (nonatomic, strong) NSMutableDictionary *stopData;
@property (nonatomic, strong) Stop *selectedStop;
@property (nonatomic, strong) NSTimer *refreshTimer;

- (void)loadStopTimes;

@end



