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

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  if(newLocation.coordinate.latitude != 0){
    [[self locationManager] stopUpdatingLocation];
    
    CLLocation *mpls = [[CLLocation alloc] initWithLatitude:44.949651 longitude:-93.242223];
    double dist = [mpls distanceFromLocation:newLocation] / 1609.344;
    if(dist > 50){
      [self setMyLocation: newLocation];
      [self loadStopsForLocation:newLocation];
      
      if(! _farAwayAlertShown){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Not from around here?"
                              message: @"Metro Transit does not service your location."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        _farAwayAlertShown = YES;
      }
      
      
    } else {
      [self setMyLocation: newLocation];
      [self loadStopsForLocation:newLocation];
    }

  }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  CLLocation *mpls = [[CLLocation alloc] initWithLatitude:44.949651 longitude:-93.242223];
  [self setMyLocation:mpls];
  UIAlertView *alert = [[UIAlertView alloc]
                        initWithTitle: @"Location Services Unavailable"
                        message: @"\nLocation Services are not available. A pre-set location will be used. Distances will not be accurate."
                        delegate: nil
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil];
  [alert show];
  [self loadStopsForLocation:mpls];

}

- (void) loadData {
  [self setMyLocation:nil];
  [self initLocation];
}

- (void) hideHUD {
  [[self HUD] hide:YES];
  _loading = NO;
}

- (void) viewDidAppear:(BOOL)animated {
  BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
  [app saveAnalytics:@"MainTableView"];
  
  if(_loading){
    [self showHUD];
  }
  [[self tableView] reloadData];
}

- (void) loadStopsForLocation:(CLLocation *)location {
  if(_lastLocation != NULL){
    if(! [self cacheLoaded]){
      [self cacheStopDB:nil];
      return;
    }
    
    double dist = [location distanceFromLocation:_lastLocation] / 1609.344;
    if(dist < 0.2){
      [[self tableView] reloadData];
      return;
    }
  }
  _lastLocation = location;
  
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  NSString *last_viewed_stop_id = [settings stringForKey: @"last_viewed_stop_id"];
  if (last_viewed_stop_id == NULL) {
    last_viewed_stop_id = @"1000";
  }

  _loading = YES;
  [Stop loadNearbyStops:self.stopsDB near:location block:^(NSDictionary *data) {
    
    if (data == NULL || ![data isKindOfClass:[NSDictionary class]]) {
      self.stops = [[NSArray alloc] init];
      [self setErrorMessage:@"Error loading data. Email support."];
    } else {
      [self setErrorMessage:@"No stops within 25 miles."];
      
      self.stops = [data objectForKey:@"stops"];
      [self setLastViewed: [data objectForKey:@"last_viewed"]];
      
      Stop* lastStop = [Stop getStopByID:last_viewed_stop_id fromArray:self.stopsDB];
      
      NSMutableDictionary *lastViewed = [[NSMutableDictionary alloc] init];
      [lastViewed setValue:lastStop forKey:@"stop"];
      [self setLastViewed: lastViewed];
      
      [self hideHUD];
    }
    
    [[self tableView] reloadData];
  }];
}


- (void) repaintTable {
    NSLog(@"RELOAD 1");
    [[self tableView] reloadData];
}

- (void) cacheStopDB:(id <BusProgressDelegate>)delegate {
  [self setCacheLoaded:false];
  
  /*
  if([DataCache isCacheStail]){
    [DataCache downloadCacheProgress:delegate main:self];
  }
   */
  
  //Load existing cache
  [DataCache loadCacheStops:^(NSArray *db) {
    [self setStopsDB:db];
    [DataCache loadCacheRoutes:^(NSArray *db) {
      [self setRoutesDB:db];
      [self setCacheLoaded:true];
    }];
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
  [self setRoutesDB:nil];
  [self setCacheLoaded:false];
}

- (void) initLocation {
  
  if( [self myLocation] == NULL) {
    CLLocation *mpls = [[CLLocation alloc] initWithLatitude:44.949651 longitude:-93.242223];
    if ([CLLocationManager locationServicesEnabled]) {
      if([self locationManager] == NULL){
        [self setLocationManager:[[CLLocationManager alloc] init]];
        [[self locationManager] setDelegate:self];
        [[self locationManager] setDistanceFilter:kCLDistanceFilterNone];
        [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
      }
    
      [[self locationManager] startUpdatingLocation];
      
    } else {
      
      [self setMyLocation:mpls];
      UIAlertView *alert = [[UIAlertView alloc]
                            initWithTitle: @"Location Services Unavailable"
                            message: @"\nLocation Services are not available. A pre-set location will be used. Distances will not be accurate."
                            delegate: nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];
      [alert show];
      
      UIApplication* app = [UIApplication sharedApplication];
      UIApplicationState state = [app applicationState];
      if (state == UIApplicationStateActive) {
        [self loadStopsForLocation:[self myLocation]];
      }
    }
  }
  
}

- (void) openSearch:(id)sender {
  SearchTableViewController *target = [[SearchTableViewController alloc] init];
  if(! [self cacheLoaded]){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Low memory condition"
                                                    message:@"Cached data was purged to free up memory, reloading ..."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self cacheStopDB:nil];
    return;
  }
  
  [target setStopsDB:[self stopsDB]];
  [target setRoutesDB:[self routesDB]];
  [target setMyLocation:[self myLocation]];
  [target setMain:self];
   
  [[self navigationController] pushViewController:target animated:YES];
}

- (void)viewDidLoad {
  [self setTableView:[[UITableView alloc] initWithFrame:CGRectMake(22, 207, 270, 233)]];

  [super viewDidLoad];

  [[self navigationItem] setTitle:kAppName];
  _farAwayAlertShown = NO;
  
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
      return 0;
    }
  } else if ([id isEqualToString:kRouteSectionID]) {
    return 1;
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
    return @"Routes";
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
    static NSString *CellIdentifier = @"RouteCell";
    NoStops* cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[NoStops alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryView:[[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    [[cell message] setText:@"Select a Route"];
    return cell;
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
  [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:[self tableView]];
}


@end