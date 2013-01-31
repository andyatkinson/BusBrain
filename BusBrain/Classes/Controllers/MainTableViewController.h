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
  CLLocation        *_lastLocation;
  CLLocationManager *_locationManager;
  NSArray           *_routes;
  NSArray           *_routesDB;
  NSArray           *_stops;
  NSArray           *_stopsDB;
  NSDictionary      *_lastViewed;
  NSTimer           *_refreshTimer;
  NSString          *_errorMessage;
  
  BOOL _dataRefreshRequested;
  BOOL _cacheLoaded;
  BOOL _loading;
}

@property (nonatomic, strong) NSMutableArray    *dataArraysForRoutesScreen;
@property (nonatomic, strong) NSArray           *stops;
@property (nonatomic, strong) NSArray           *routes;
@property (nonatomic, strong) NSArray           *routesDB;
@property (nonatomic, strong) NSArray           *stopsDB;
@property (nonatomic, strong) NSDictionary      *lastViewed;
@property (nonatomic, strong) CLLocation        *myLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer           *refreshTimer;
@property (nonatomic, strong) NSString          *errorMessage;
@property (nonatomic)         int               fetchCount;
@property (nonatomic)         BOOL              dataRefreshRequested;
@property (nonatomic)         BOOL              cacheLoaded;

- (void) initData:(id <BusProgressDelegate>)delegate;
- (void) initLocation;
- (void) purgeCachedData;
- (void) hideHUD;

@end

