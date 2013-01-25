//
//  RoutesTableViewController.m
//
//

#import "BusBrainAppDelegate.h"
#import "BusTable.h"
#import "MainTableViewController.h"
#import "SearchTableViewController.h"
#import "Route.h"
#import "Stop.h"
#import "StopCell.h"
#import "NoStops.h"
#import "RouteTableViewController.h"
#import "NSString+BeetleFight.h"
#import "DataCache.h"

#import "TransitAPIClient.h"
#import "AFJSONRequestOperation.h"

#import "BusBrainAppDelegate.h"
#import "NSDate+BusBrain.h"

NSString * const kStopSectionID   = @"STOP";
NSString * const kLastSectionID   = @"LAST";
NSString * const kRouteSectionID  = @"ROUTE";

@implementation MainTableViewController

@synthesize dataArraysForRoutesScreen = _dataArraysForRoutesScreen;
@synthesize routes                    = _routes;
@synthesize routesDB                  = _routesDB;
@synthesize stops                     = _stops;
@synthesize stopsDB                   = _stopsDB;
@synthesize lastViewed                = _lastViewed; 
@synthesize locationManager           = _locationManager; 
@synthesize myLocation                = _myLocation;
@synthesize refreshTimer              = _refreshTimer;
@synthesize dataRefreshRequested      = _dataRefreshRequested;
@synthesize fetchCount                = _fetchCount;
@synthesize cacheLoaded               = _cacheLoaded;
@synthesize surpressHUD               = _surpressHUD;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  [self loadDataForLocation:newLocation];
  [self setMyLocation: newLocation];
  [[self locationManager] stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to acquire location."
                        message:nil
                        delegate:nil
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil];
  [alert show];

}

- (void) loadData {
  [self setMyLocation:nil];
  [self initLocation];
}

- (void) hideHUD {
  if([self fetchCount] < 1) {
    [[self HUD] hide:YES];
  }
}

- (void) viewDidAppear:(BOOL)animated {
  BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
  [app saveAnalytics:@"MainTableView"];
  
  [[self tableView] reloadData];
}

- (void) loadStopsForLocation:(CLLocation *)location {
  
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  if (location) {
		[params setValue:[NSString stringWithFormat:@"%1.7f", location.coordinate.latitude] forKey:@"lat"];
		[params setValue:[NSString stringWithFormat:@"%1.7f", location.coordinate.longitude] forKey:@"lon"];
	}
  
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  NSString *last_viewed_stop_id = [settings stringForKey: @"last_viewed_stop_id"];
  if (last_viewed_stop_id != NULL) {
    [params setValue:last_viewed_stop_id forKey:@"last_viewed_stop_id"];
  } else {
    [params setValue:@"1000" forKey:@"last_viewed_stop_id"];
  }
  
  //Get hour and minute from device, and send as params to do time calculation
  NSDate *now = [NSDate timeRightNow];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:now];
  [params setValue:[NSString stringWithFormat:@"%d", [components hour]] forKey:@"hour"];
  [params setValue:[NSString stringWithFormat:@"%d", [components minute]] forKey:@"minute"];
  

  if(location.coordinate.latitude == 0){
    return;
  }
  
  [Stop loadNearbyStopsFromDB:self.stopsDB near:location parameters:params block:^(NSDictionary *data) {
    
    if (data == NULL || ![data isKindOfClass:[NSDictionary class]]) {
      self.stops = [[NSArray alloc] init];
      [self setErrorMessage:@"Error loading data. Email support."];
    } else {
      [self setErrorMessage:@"No stops within 25 miles."];
      
      self.stops = [data objectForKey:@"stops"];
      [self setLastViewed: [data objectForKey:@"last_viewed"]];
      
      //[self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self setFetchCount: [self fetchCount] - 1];
    [self hideHUD];
    [[self tableView] reloadData];
  }];
}


- (void) repaintTable {
    NSLog(@"RELOAD 1");
    [[self tableView] reloadData];
}

- (void) loadDataForLocation:(CLLocation *)location {
  
  if(! [self surpressHUD]){
    [self showHUD];
  }

  //Since we are WERE kicking off multiple requests that could come back in a different order
  //We need to keep track of it and each caller needs to decreemnt the fetchCount and
  //call hideHUD
  
  [self setFetchCount: 1];
  
  [self loadStopsForLocation:location];

}

- (void) cacheStopDB:(id <BusProgressDelegate>)delegate {
  [self setCacheLoaded:false];
  [DataCache downloadCacheProgress:delegate main:self];
  
  //Load existing cache
  [DataCache loadCacheStops:^(NSArray *db) {
    [self setStopsDB:db];
  }];
  [DataCache loadCacheRoutes:^(NSArray *db) {
    [self setRoutesDB:db];
    [self setCacheLoaded:true];
  }];
  
}

- (void) initData:(id <BusProgressDelegate>)delegate {
  [self cacheStopDB:delegate];
  
  Stop *s1 = [[Stop alloc] initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Loading...", @"stop_desc", nil]];
  [self setStops:[NSArray arrayWithObjects:s1, nil]];

  
  NSDictionary *lastStopIDDict = [NSDictionary dictionaryWithObject:kLastSectionID forKey:@"id"];
  NSDictionary *stopsDict      = [NSDictionary dictionaryWithObject:kStopSectionID forKey:@"id"];
  NSDictionary *routesDict     = [NSDictionary dictionaryWithObject:kRouteSectionID forKey:@"id"];

  [self setDataArraysForRoutesScreen: [[NSMutableArray alloc] init]];

  [[self dataArraysForRoutesScreen] addObject:stopsDict];
  [[self dataArraysForRoutesScreen] addObject:lastStopIDDict];
  [[self dataArraysForRoutesScreen] addObject:routesDict];

}

- (void) purgeCachedData {
#ifdef DEBUG_BB
  NSLog(@"Cache Dumped");
#endif
  [self setStopsDB:nil];
}

- (void) initLocation {
  
  if( [self myLocation] == NULL) {
    CLLocation *mpls = [[CLLocation alloc] initWithLatitude:44.949651 longitude:-93.242223];
    if ([CLLocationManager locationServicesEnabled]) {
      [self setLocationManager:[[CLLocationManager alloc] init]];
      [[self locationManager] setDelegate:self];
      [[self locationManager] setDistanceFilter:kCLDistanceFilterNone];
      [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
      [[self locationManager] startUpdatingLocation];
      
    } else {
      
      [self setMyLocation:mpls];
      UIAlertView *alert = [[UIAlertView alloc]
                            initWithTitle: @"Location Services Unavailable"
                            message: @"\n\nLocation Services are not available. A pre-set location will be used. Distances will not be accurate."
                            delegate: nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];
      [alert show];
      
      UIApplication* app = [UIApplication sharedApplication];
      UIApplicationState state = [app applicationState];
      if (state == UIApplicationStateActive) {
        [self loadDataForLocation:[self myLocation]];
      }
    }
  }
  
}

- (void) openSearch:(id)sender {
  SearchTableViewController *target = [[SearchTableViewController alloc] init];
  [target setStopsDB:[self stopsDB]];
  [target setMyLocation:[self myLocation]];
  [target setMain:self];
   
  [[self navigationController] pushViewController:target animated:YES];
}

- (void)viewDidLoad {
  [self setTableView:[[UITableView alloc] initWithFrame:CGRectMake(22, 207, 270, 233)]];

  [super viewDidLoad];

  [[self navigationItem] setTitle:kAppName];

  UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [searchButton setFrame:CGRectMake(0.0f, 0.0f, 35.0f, 30.0f)];
  [searchButton addTarget:self action:@selector(openSearch:) forControlEvents:UIControlEventTouchUpInside];
  [searchButton setImage:[UIImage imageNamed:@"btn_search_norm.png"] forState:UIControlStateNormal];
  [searchButton setImage:[UIImage imageNamed:@"btn_search_down.png"] forState:UIControlStateHighlighted];
  [searchButton setImage:[UIImage imageNamed:@"btn_search_down.png"] forState:UIControlStateSelected];
  UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
  self.navigationItem.rightBarButtonItem = searchButtonItem;
  
  
 
  [[self tableView] setDelegate:self];
  [[self tableView] setDataSource:self];
  [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]]];
  [self setView:[self tableView]];

  [self loadDataForLocation:[self myLocation]];
  
  [self initPullRefresh];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  return [[self dataArraysForRoutesScreen] count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  NSString *id = [[[self dataArraysForRoutesScreen] objectAtIndex:section] valueForKeyPath:@"id"];

  if ([id isEqualToString:kLastSectionID] ) {

    Stop *stop = (Stop *)[[self lastViewed] valueForKey:@"stop"];
    if (stop) {
      return 1;
    } else {
      return 0;
    }

  } else if ([id isEqualToString:kStopSectionID]) {
    if([[self stops] count] > 1){
      return [[self stops] count];
    } else {
      return 1;
    }
  } else if ([id isEqualToString:kRouteSectionID]) {
    if([[self stops] count] > 1){
      return 1;
    } else {
      return 0;
    }
  } else {
    return 0;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSString *id = [[[self dataArraysForRoutesScreen] objectAtIndex:section] valueForKeyPath:@"id"];

  if ([id isEqualToString:kLastSectionID]) {

    Stop *stop = (Stop *)[[self lastViewed] valueForKey:@"stop"];
    if (stop) {
      return @"Last Viewed";
    } else {
      return NULL;
    }

  } else if ([id isEqualToString:kStopSectionID]) {
    if([[self stops] count] > 1){
      return @"Stops Near You";
    } else {
      return NULL;
    }
    
  } else if ([id isEqualToString:kRouteSectionID]) {
    if([[self stops] count] > 1){
      return @"Routes";
    } else {
      return NULL;
    }
  }
  
  return NULL;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  int section = [indexPath section];
  NSString *id = [[[self dataArraysForRoutesScreen] objectAtIndex:section] valueForKeyPath:@"id"];

  if ( [id isEqualToString:kLastSectionID] )  {

    static NSString *CellIdentifier = @"LastCell";
    StopCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[StopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    Stop *stop = (Stop *)[[self lastViewed] valueForKey:@"stop"];
    [stop setRoute:nil];
    [cell setStop: stop];
    [cell setAccessoryView: [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    return cell;


  } else if ( [id isEqualToString:kStopSectionID] )  {
      
     if([[self stops] count] > 0){
        static NSString *CellIdentifier = @"StopCell";
        StopCell* cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
          cell = [[StopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
      
        Stop *stop = (Stop *)[[self stops] objectAtIndex:[indexPath row]];
        [stop setRoute:nil];
        [cell setStop: stop];
       
        [cell setAccessoryView:[[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        return cell;
      
      } else {
        static NSString *CellIdentifier = @"NoStops";
        NoStops* cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
          cell = [[NoStops alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [[cell message] setText:[self errorMessage]];
        return cell;
      }
    
  } else if ([id isEqualToString:kRouteSectionID]) {
    if([[self stops] count] > 1){
      static NSString *CellIdentifier = @"RouteCell";
      NoStops* cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
        cell = [[NoStops alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      }
      [cell setAccessoryView:[[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]]];
      [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
      
      [[cell message] setText:@"Select a Route"];
      return cell;
    } else {
      return NULL;
    }
    
  }

  return NULL;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  int section = [indexPath section];
  NSString *id = [[[self dataArraysForRoutesScreen] objectAtIndex:section] valueForKeyPath:@"id"];

  if ( [id isEqualToString:kLastSectionID] )  {

    Stop *stop = (Stop *)[[self lastViewed] valueForKey:@"stop"];
    RouteTableViewController *target = [[RouteTableViewController alloc] init];
    [target loadRoutesForStop:stop];
    
    [[self navigationController] pushViewController:target animated:YES];

  } else if ( [id isEqualToString:kStopSectionID] )  {
    
    if([[self stops] count] > 0){
      Stop *stop = (Stop *)[[self stops] objectAtIndex:[indexPath row]];
      RouteTableViewController *target = [[RouteTableViewController alloc] init];
      [target loadRoutesForStop:stop];
      
      [[self navigationController] pushViewController:target animated:YES];
    } else {
      [self repaintTable];
    }
  } else if ([id isEqualToString:kRouteSectionID]) {
    RouteTableViewController *target = [[RouteTableViewController alloc] init];
    [target setRoutes:[self routesDB]];
    [[target navigationItem] setTitle: @"Routes" ];
    [[self navigationController] pushViewController:target animated:YES];
  }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 57;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)doneLoadingTableViewData {

  //  model should call this when its done loading
  //_reloading = NO;
  [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:[self tableView]];
}


@end