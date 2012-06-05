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
  
}

@property (nonatomic, retain) CLLocation        *myLocation;
@property (nonatomic, retain) NSArray           *stopsDB;
@property (nonatomic, retain) NSArray           *searchArray;

- (void) performSearch:(NSString*) searchString;

@end
