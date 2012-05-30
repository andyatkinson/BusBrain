//
//  RoutesTableViewController.h
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"

@interface MainTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MBProgressHUDDelegate, EGORefreshTableHeaderDelegate> {
  UITableView       *tableView;
  NSMutableArray    *dataArraysForRoutesScreen;
  CLLocation        *myLocation;
  CLLocationManager *locationManager;
  NSArray           *routes;
  NSArray           *stops;
  NSDictionary      *lastViewed;
  MBProgressHUD     *HUD;
  EGORefreshTableHeaderView *_refreshHeaderView;
  int _fetchCount;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArraysForRoutesScreen;
@property (nonatomic, retain) NSArray *routes;
@property (nonatomic, retain) NSArray *stops;
@property (nonatomic, retain) NSDictionary *lastViewed;

@property (nonatomic, retain) CLLocation *myLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)loadDataForLocation:(CLLocation *)location;
- (void)loadStopsForLocation:(CLLocation *)location;

@end
