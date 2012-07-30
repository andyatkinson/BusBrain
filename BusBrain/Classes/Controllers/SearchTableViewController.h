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
  
}

@property (nonatomic, retain) CLLocation        *myLocation;
@property (nonatomic, retain) NSArray           *stopsDB;
@property (nonatomic, retain) NSArray           *searchArray;
@property (nonatomic, retain) UISearchBar       *searchBar;

- (void) performSearch:(NSString*) searchString;
- (void) toggleSearch:(id)sender;

@end
