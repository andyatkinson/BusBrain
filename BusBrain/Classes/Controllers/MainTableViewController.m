//
//  RoutesTableViewController.m
//
//

#import "MainTableViewController.h"
#import "RouteCell.h"
#import "Route.h"
#import "Stop.h"
#import "StopTimesTableViewController.h"
#import "NSString+BeetleFight.h"

NSString * const kStopSectionID = @"STOP";
NSString * const kLastSectionID  = @"LAST";

@implementation MainTableViewController

@synthesize tableView, dataArraysForRoutesScreen, routes, stops, lastViewed, locationManager, myLocation;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  [self loadDataForLocation:newLocation];
  self.myLocation = newLocation;
  [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to acquire location."
                        message:nil
                        delegate:nil
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil];
  [alert show];
  [alert release];

}

- (void) hideHUD {
  if(_fetchCount == 1) {
    [HUD hide:YES];
  }
}

- (void) loadStopsForLocation:(CLLocation *)location {

  [Stop stopsFromPlist:location block:^(NSArray *stopData) {
     self.stops = stopData;
     [self.tableView reloadData];

     [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];

     _fetchCount++;
     [self hideHUD];

     [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];

   }];

}

- (void) loadDataForLocation:(CLLocation *)location {
  /* Progress HUD overlay START */
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  HUD = [[MBProgressHUD alloc] initWithWindow:window];
  [window addSubview:HUD];
  HUD.delegate = self;
  HUD.labelText = @"Loading";
  [HUD show:YES];
  _fetchCount = 0;
  /* Progress HUD overlay END */


  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  NSString *last_stop_id = [settings stringForKey: @"last_stop_id"];
  if (last_stop_id != NULL) {
    //Load Last Stop Data
  }

  [self loadStopsForLocation:location];

}

- (void) initData {

  Stop *s1 = [[Stop alloc] initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Loading...", @"stop_desc", nil]];
  self.stops = [NSArray arrayWithObjects:s1, nil];

  NSDictionary *lastStopIDDict = [NSDictionary dictionaryWithObject:kLastSectionID forKey:@"id"];
  NSDictionary *stopsDict      = [NSDictionary dictionaryWithObject:kStopSectionID forKey:@"id"];

  dataArraysForRoutesScreen = [[NSMutableArray alloc] init];
  [dataArraysForRoutesScreen addObject:lastStopIDDict];
  [dataArraysForRoutesScreen addObject:stopsDict];

}

- (void) initPullRefresh {
  if (_refreshHeaderView == nil) {
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
    view.delegate = self;
    [self.tableView addSubview:view];
    _refreshHeaderView = view;
    [view release];
  }

  //  update the last update date
  [_refreshHeaderView refreshLastUpdatedDate];
}

- (void) initLocation {
  if( self.myLocation == NULL) {
    CLLocation *mpls = [[CLLocation alloc] initWithLatitude:44.949651 longitude:-93.242223];

    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
      self.myLocation = mpls;
      [self loadDataForLocation:self.myLocation];
    } else {
      if([CLLocationManager locationServicesEnabled]) {
        [self setLocationManager:[[CLLocationManager alloc] init]];
        [[self locationManager] setDelegate:self];
        [[self locationManager] setDistanceFilter:kCLDistanceFilterNone];
        [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [[self locationManager] startUpdatingLocation];
      } else {
        self.myLocation = mpls;
        [self loadDataForLocation:self.myLocation];
      }
    }
  } else {
    [self loadDataForLocation:self.myLocation];
  }
}

- (void)viewDidLoad {
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(22, 207, 270, 233)];

  [super viewDidLoad];

  self.navigationItem.title = @"bus brain";
  self.tableView.delegate   = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
  self.view = self.tableView;

  [self initData];
  [self initPullRefresh];

  [self initLocation];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  return [dataArraysForRoutesScreen count];
}

- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
  if ([self tableView:tv titleForHeaderInSection:section] != nil) {
    return 28; // want to eliminate a 1px bottom gray line, and a 1px bottom white line under
  }
  else {
    // If no section header title, no section header needed
    return 0;
  }
}

- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section {

  UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.frame.size.width,30)] autorelease];

  UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,headerView.frame.size.width, headerView.frame.size.height)];
  headerLabel.textAlignment = UITextAlignmentLeft;
  headerLabel.textColor = [UIColor blackColor];
  headerLabel.text = [self tableView:tv titleForHeaderInSection:section];
  headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
  headerLabel.shadowColor = [UIColor whiteColor];
  headerLabel.shadowOffset = CGSizeMake(0,1);

  headerLabel.backgroundColor = [UIColor clearColor];
  [headerView addSubview:headerLabel];

  headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header_bar_default.png"]];

  return headerView;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  NSString *id = [[dataArraysForRoutesScreen objectAtIndex:section] valueForKeyPath:@"id"];

  if ([id isEqualToString:kStopSectionID] ) {

    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *last_stop_id = [settings stringForKey: @"last_stop_id"];
    if (last_stop_id != NULL) {
      return 1;
    } else {
      return 0;
    }

  } else if ([id isEqualToString:kLastSectionID]) {
    return [self.stops count];
  } else {
    // should not reach here
    return 0;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSString *id = [[dataArraysForRoutesScreen objectAtIndex:section] valueForKeyPath:@"id"];

  if ([id isEqualToString:kStopSectionID]) {

    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *last_stop_id = [settings stringForKey: @"last_stop_id"];
    if (last_stop_id != NULL) {
      return @"Last Viewed";

    } else {
      return NULL;
    }

  } else if ([id isEqualToString:kLastSectionID]) {
    return @"Stops Near You";
  }
  return NULL;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *CellIdentifier = @"Cell";

  int section = indexPath.section;
  NSString *id = [[dataArraysForRoutesScreen objectAtIndex:section] valueForKeyPath:@"id"];

  if ( [id isEqualToString:kStopSectionID] )  {

    RouteCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    Stop *stop = (Stop *)[self.lastViewed valueForKey:@"stop"];
    cell.title.text = stop.stop_name;
    cell.description.text = stop.stop_desc;
    if ([self.lastViewed valueForKey:@"next_depature"]) {
      cell.extraInfo.text = [[self.lastViewed valueForKey:@"next_departure"] hourMinuteFormatted];
    }
    cell.icon.image = [UIImage imageNamed:stop.icon_path];
    cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]];

    return cell;


  } else if ( [id isEqualToString:kLastSectionID] )  {

    RouteCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    Stop *stop = (Stop *)[self.stops objectAtIndex:indexPath.row];
    cell.title.text = stop.stop_name;
    cell.description.text = stop.stop_desc;

    double dist = [self.myLocation distanceFromLocation:stop.location] / 1609.344;

    cell.extraInfo.text = [NSString stringWithFormat:@"%.1f miles", dist];
    cell.icon.image = [UIImage imageNamed:stop.icon_path];
    cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]];

    return cell;
  }

  return NULL;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  int section = indexPath.section;
  NSString *id = [[dataArraysForRoutesScreen objectAtIndex:section] valueForKeyPath:@"id"];

  if ( [id isEqualToString:kStopSectionID] )  {

    Stop *stop = (Stop *)[self.lastViewed valueForKey:@"stop"];
    StopTimesTableViewController *target = [[StopTimesTableViewController alloc] init];
    [target setSelectedStop:stop];

    [[self navigationController] pushViewController:target animated:YES];

  } else if ( [id isEqualToString:kLastSectionID] )  {

    Stop *stop = (Stop *)[self.stops objectAtIndex:indexPath.row];
    StopTimesTableViewController *target = [[StopTimesTableViewController alloc] init];
    [target setSelectedStop:stop];
    [target setSelectedRoute:stop.route];

    [[self navigationController] pushViewController:target animated:YES];
  }

}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {

  //return UITableViewCellAccessoryDetailDisclosureButton;
  return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tv accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

  [self tableView:tv didSelectRowAtIndexPath:indexPath];
}

-(void)hudWasHidden {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  // indexPath.section && indexPath.row (inside a section) are options to control in more detail
  return 57;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  //[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
  [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)doneLoadingTableViewData {

  //  model should call this when its done loading
  //_reloading = NO;
  //[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
  [self loadDataForLocation:self.myLocation];
  [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];

}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {

  //return _reloading; // should return if data source model is reloading
  return NO;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {

  return [NSDate date];       // should return date data source was last changed

}

- (void)dealloc {

  [dataArraysForRoutesScreen release];
  [super dealloc];
  [HUD dealloc];
}

@end