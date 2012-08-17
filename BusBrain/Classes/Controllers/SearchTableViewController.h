//
//  RoutesTableViewController.h
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BusTable.h"
#import "MBProgressHUD.h"

@interface SearchTableViewController : BusTable <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
  CLLocation        *_myLocation;
  NSArray           *_stopsDB;
  NSArray           *_searchArray;
  UISearchBar       *_searchBar;
  UIView            *_greyView;
  UILabel           *_message;
  dispatch_queue_t   _queueSearch;
  int                _pendingSearches;
  
}

@property (nonatomic, retain) CLLocation        *myLocation;
@property (nonatomic, retain) NSArray           *stopsDB;
@property (nonatomic, retain) NSArray           *searchArray;
@property (nonatomic, retain) UISearchBar       *searchBar;
@property (nonatomic, retain) UIView            *greyView;
@property (nonatomic, retain) UILabel           *message;

- (void) performSearch:(NSString*) searchString;

@end
