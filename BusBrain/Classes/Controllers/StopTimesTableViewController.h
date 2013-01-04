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
#import "CountDownView.h"
#import "MainTableViewController.h"

@interface StopTimesTableViewController : BusTable <UITableViewDelegate, UITableViewDataSource> {
  NSMutableArray *_data;
  Route          *_selectedRoute;
  Stop           *_selectedStop;
  NSArray        *_stopTimes;
  CountDownView  *_countDownView;
  NSMutableArray      *_stopHours;
  NSMutableDictionary *_stopData;
  
  NSTimer        *_refreshTimer;
  MainTableViewController *_main;
}

@property (nonatomic, retain) CountDownView *countDownView;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSArray *stopTimes;
@property (nonatomic, retain) NSMutableArray *stopHours;
@property (nonatomic, retain) NSMutableDictionary *stopData;
@property (nonatomic, retain) Stop *selectedStop;
@property (nonatomic, retain) NSTimer *refreshTimer;
@property (nonatomic, retain) MainTableViewController *main;

- (void)loadStopTimes;

@end



