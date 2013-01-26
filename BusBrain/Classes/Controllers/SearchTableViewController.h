//
//  RoutesTableViewController.h
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BusTable.h"
#import "MBProgressHUD.h"
#import "MainTableViewController.h"

@interface SearchTableViewController : BusTable <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
  CLLocation        *_myLocation;
  NSArray           *_stopsDB;
  NSArray           *_storeSearchArray;
  NSArray           *_routeSearchArray;
  UISearchBar       *_searchBar;
  UIView            *_greyView;
  UILabel           *_message;
  dispatch_queue_t   _queueSearch;
  int                _pendingSearches;
  MainTableViewController *_main;
}

@property (nonatomic, strong) CLLocation        *myLocation;
@property (nonatomic, strong) NSArray           *stopsDB;
@property (nonatomic, strong) NSArray           *routesDB;
@property (nonatomic, strong) NSArray           *storeSearchArray;
@property (nonatomic, strong) NSArray           *routeSearchArray;
@property (nonatomic, strong) UISearchBar       *searchBar;
@property (nonatomic, strong) UIView            *greyView;
@property (nonatomic, strong) UILabel           *message;
@property (nonatomic, strong) MainTableViewController *main;

- (void) performSearch:(NSString*) searchString;

@end
