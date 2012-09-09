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
  NSArray           *_stops;
  NSArray           *_stopsDB;
  NSDictionary      *_lastViewed;
  NSTimer           *_refreshTimer;
  NSString          *_errorMessage;
  
  int  _fetchCount;
  BOOL _dataRefreshRequested;
  BOOL _cacheLoaded;
}

@property (nonatomic, retain) NSMutableArray    *dataArraysForRoutesScreen;
@property (nonatomic, retain) NSArray           *stops;
@property (nonatomic, retain) NSArray           *stopsDB;
@property (nonatomic, retain) NSDictionary      *lastViewed;
@property (nonatomic, retain) CLLocation        *myLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSTimer           *refreshTimer;
@property (nonatomic, retain) NSString          *errorMessage;
@property (nonatomic)         int               fetchCount;
@property (nonatomic)         BOOL              dataRefreshRequested;
@property (nonatomic)         BOOL              cacheLoaded;

- (void) initData:(id <BusProgressDelegate>)delegate;
- (void) initLocation;
- (BOOL) isCacheStail;
- (void) purgeCachedData;

- (void) downloadCache:(id <BusProgressDelegate>)delegate;

@end

@protocol BusProgressDelegate
- (void) setProgress:(float) progress;
- (void) dismiss;
@end