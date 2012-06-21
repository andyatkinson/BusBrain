//
//  RoutesTableViewController.h
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BusTable.h"

@protocol BusProgressDelegate;

@interface MainTableViewController : BusTable <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate> {
  NSMutableArray    *_dataArraysForRoutesScreen;
  CLLocation        *_myLocation;
  CLLocationManager *_locationManager;
  NSArray           *_routes;
  NSArray           *_stopsDisplayed;
  NSArray           *_stopsDB;
  NSDictionary      *_lastViewed;
  NSTimer           *_refreshTimer;
  
  int  _fetchCount;
  BOOL _dataRefreshRequested;
  BOOL _cacheLoaded;
}

@property (nonatomic, retain) NSMutableArray    *dataArraysForRoutesScreen;
@property (nonatomic, retain) NSArray           *routes;
@property (nonatomic, retain) NSArray           *stopsDisplayed;
@property (nonatomic, retain) NSArray           *stopsDB;
@property (nonatomic, retain) NSDictionary      *lastViewed;
@property (nonatomic, retain) CLLocation        *myLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSTimer           *refreshTimer;
@property (nonatomic)         int               fetchCount;
@property (nonatomic)         BOOL              dataRefreshRequested;
@property (nonatomic)         BOOL              cacheLoaded;

- (void) initData:(id <BusProgressDelegate>)delegate;
- (void) initLocation;
- (BOOL) isCacheStail;
- (void) purgeCachedData;
- (void) loadDataForLocation:(CLLocation *)location;
- (void) loadStopsForLocation:(CLLocation *)location;
- (void) downloadCache:(id <BusProgressDelegate>)delegate;

@end

@protocol BusProgressDelegate
- (void) setProgress:(float) progress;
- (void) dismiss;
@end