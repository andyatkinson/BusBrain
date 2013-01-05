//
//  RoutesTableViewController.h
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BusTable.h"
#import "DataCache.h"


@interface MainTableViewController : BusTable <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, BusMainDelegate> {
  NSMutableArray    *_dataArraysForRoutesScreen;
  CLLocation        *_myLocation;
  CLLocationManager *_locationManager;
  NSArray           *_routes;
  NSArray           *_routesDB;
  NSArray           *_stops;
  NSArray           *_stopsDB;
  NSDictionary      *_lastViewed;
  NSTimer           *_refreshTimer;
  NSString          *_errorMessage;
  
  int  _fetchCount;
  BOOL _dataRefreshRequested;
  BOOL _cacheLoaded;
  BOOL _surpressHUD;
}

@property (nonatomic, retain) NSMutableArray    *dataArraysForRoutesScreen;
@property (nonatomic, retain) NSArray           *stops;
@property (nonatomic, retain) NSArray           *routes;
@property (nonatomic, retain) NSArray           *routesDB;
@property (nonatomic, retain) NSArray           *stopsDB;
@property (nonatomic, retain) NSDictionary      *lastViewed;
@property (nonatomic, retain) CLLocation        *myLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSTimer           *refreshTimer;
@property (nonatomic, retain) NSString          *errorMessage;
@property (nonatomic)         int               fetchCount;
@property (nonatomic)         BOOL              dataRefreshRequested;
@property (nonatomic)         BOOL              cacheLoaded;
@property (nonatomic)         BOOL              surpressHUD;

- (void) initData:(id <BusProgressDelegate>)delegate;
- (void) initLocation;
- (void) purgeCachedData;

@end

