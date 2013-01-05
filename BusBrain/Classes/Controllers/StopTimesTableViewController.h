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

@property (nonatomic, strong) CountDownView *countDownView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSArray *stopTimes;
@property (nonatomic, strong) NSMutableArray *stopHours;
@property (nonatomic, strong) NSMutableDictionary *stopData;
@property (nonatomic, strong) Stop *selectedStop;
@property (nonatomic, strong) NSTimer *refreshTimer;
@property (nonatomic, strong) MainTableViewController *main;

- (void)loadStopTimes;

@end



