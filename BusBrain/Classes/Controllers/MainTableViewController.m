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
#import "StopMainCell.h"
#import "StopLastCell.h"
#import "StopTimesTableViewController.h"
#import "NSString+BeetleFight.h"

NSString * const kStopSectionID   = @"STOP";
NSString * const kLastSectionID   = @"LAST";

@implementation MainTableViewController

@synthesize dataArraysForRoutesScreen = _dataArraysForRoutesScreen; 
@synthesize routes                    = _routes; 
@synthesize stopsDisplayed            = _stopsDisplayed; 
@synthesize stopsDB                   = _stopsDB; 
@synthesize lastViewed                = _lastViewed; 
@synthesize locationManager           = _locationManager; 
@synthesize myLocation                = _myLocation;
@synthesize refreshTimer              = _refreshTimer;
@synthesize dataRefreshRequested      = _dataRefreshRequested;
@synthesize fetchCount                = _fetchCount;
@synthesize cacheLoaded               = _cacheLoaded;

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
  [alert release];

}

- (void) loadData {
  [self loadDataForLocation:[self myLocation]];
}

- (void) hideHUD {
  if([self fetchCount] == 0) {
    [[self HUD] hide:YES];
  }
}

- (void) loadStopsForLocation:(CLLocation *)location {
  
  [Stop nearbyStops:location block:^(NSArray *stopData) {
    [self setStopsDisplayed:stopData];
    
    NSEnumerator *e = [[self stopsDisplayed] objectEnumerator];
    Stop *stop;
    while (stop = [e nextObject]) {
     [stop loadNextStopTime];
    }

    [[self tableView] reloadData];
    [[self tableView] reloadRowsAtIndexPaths:[[self tableView] indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];

    [self setFetchCount: [self fetchCount] - 1];
    [self hideHUD];

    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:[self tableView]];

   }];

}

- (void) loadLastViewedStop {
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  NSString *last_route_id = [settings stringForKey: @"last_route_id"];
  NSString *last_stop_id  = [settings stringForKey: @"last_stop_id"];
  
  if (last_route_id != NULL && last_stop_id != NULL) {
    [Stop getStops:last_route_id stop_id:last_stop_id  block:^(NSArray *data) {
      
      if ( [data count] > 0 ){
        Stop *stop = [data objectAtIndex:0];
        
        [stop loadRoute:last_route_id];
        
        [[self lastViewed] setValue:stop forKey:@"stop"];
      }
      
      [self setFetchCount: [self fetchCount] - 1];
      [self hideHUD];
      
    }];
  } else {
    [self setFetchCount: [self fetchCount] - 1];
    [self hideHUD];
  }
  
}

- (void) repaintTable {
    if([self dataRefreshRequested]){
      [self setDataRefreshRequested: false];
      [self loadDataForLocation:[self myLocation]];
    } else {
      [[self tableView] reloadData];
    }
}

- (void) loadDataForLocation:(CLLocation *)location {
  [self showHUD];

  [self setFetchCount: 2];
  [self loadStopsForLocation:location];
  [self loadLastViewedStop];

}

- (void) purgeCachedData {
#ifdef DEBUG_BB
  NSLog(@"Cache Dumped");
#endif
  [self setStopsDB:nil];
}

-(void) cacheStopDB {
  [self setCacheLoaded:false];
#ifdef DEBUG_BB
  NSLog(@"Cache Started");
#endif
  [Stop loadStopsDB:^(NSArray *db) {
    [self setStopsDB:db];
    [self setCacheLoaded:true];
#ifdef DEBUG_BB
    NSLog(@"Cache Compelte %d", [db count]);
#endif
  }];
}

- (void) initData {
  [self cacheStopDB];
  
  Stop *s1 = [[Stop alloc] initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Loading...", @"stop_desc", nil]];
  [self setStopsDisplayed:[NSArray arrayWithObjects:s1, nil]];

  
  NSDictionary *lastStopIDDict = [NSDictionary dictionaryWithObject:kLastSectionID forKey:@"id"];
  NSDictionary *stopsDict      = [NSDictionary dictionaryWithObject:kStopSectionID forKey:@"id"];

  [self setDataArraysForRoutesScreen: [[NSMutableArray alloc] init]];

  [[self dataArraysForRoutesScreen] addObject:stopsDict];
  [[self dataArraysForRoutesScreen] addObject:lastStopIDDict];
  
  [self setLastViewed:[[NSMutableDictionary alloc] init]];

}

- (void) initLocation {
  if( [self myLocation] == NULL) {
    CLLocation *mpls = [[CLLocation alloc] initWithLatitude:44.949651 longitude:-93.242223];

    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
      [self setMyLocation: mpls];
      [self loadDataForLocation:[self myLocation]];
    } else {
      if([CLLocationManager locationServicesEnabled]) {
        [self setLocationManager:[[CLLocationManager alloc] init]];
        [[self locationManager] setDelegate:self];
        [[self locationManager] setDistanceFilter:kCLDistanceFilterNone];
        [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [[self locationManager] startUpdatingLocation];
      } else {
        [self setMyLocation: mpls];
        [self loadDataForLocation:[self myLocation]];
      }
    }
  } else {
    [self loadDataForLocation:[self myLocation]];
  }
}

- (void) openSearch:(id)sender {
  SearchTableViewController *target = [[SearchTableViewController alloc] init];
  [target setStopsDB:[self stopsDB]];
  [target setMyLocation:[self myLocation]];
   
  [[self navigationController] pushViewController:target animated:YES];
}

- (void)viewDidLoad {
  [self setTableView:[[UITableView alloc] initWithFrame:CGRectMake(22, 207, 270, 233)]];

  [super viewDidLoad];

  [[self navigationItem] setTitle:kAppName];
  
  UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                   target:self
                                   action:@selector(openSearch:)];
  [searchButton setTintColor:[UIColor blackColor]];
   
  [[self navigationItem] setRightBarButtonItem:searchButton];
 
  [[self tableView] setDelegate:self];
  [[self tableView] setDataSource:self];
  [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]]];
  [self setView:[self tableView]];

  [self initData];
  [self initPullRefresh];
  [self initLocation];
  
  [self setDataRefreshRequested:false];
  [self setRefreshTimer: [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(repaintTable)
                                                        userInfo:nil
                                                         repeats:YES]];
}

- (void)viewDidAppear {

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
    return [[self stopsDisplayed] count];
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
    return @"Stops Near You";
  }
  
  return NULL;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  int section = [indexPath section];
  NSString *id = [[[self dataArraysForRoutesScreen] objectAtIndex:section] valueForKeyPath:@"id"];

  if ( [id isEqualToString:kLastSectionID] )  {

    static NSString *CellIdentifier = @"LastCell";
    StopLastCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[StopLastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    Stop *stop = (Stop *)[[self lastViewed] valueForKey:@"stop"];
    [cell setStop: stop];
    if ( [cell dataRefreshRequested] ) {
      [stop loadNextStopTime];
      [cell setDataRefreshRequested:false];
    }
    [cell setAccessoryView: [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;


  } else if ( [id isEqualToString:kStopSectionID] )  {

    Stop *stop = (Stop *)[[self stopsDisplayed] objectAtIndex:[indexPath row]];
    
      static NSString *CellIdentifier = @"StopCell";
      StopMainCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
        cell = [[[StopMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      }
      
      [cell setStop: stop];
      
      if ( [cell dataRefreshRequested] ) {
        [stop loadNextStopTime];
        [cell setDataRefreshRequested:false];
      }
      [cell setAccessoryView:[[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]]];
      [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
      return cell;
    
  }

  return NULL;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  int section = [indexPath section];
  NSString *id = [[[self dataArraysForRoutesScreen] objectAtIndex:section] valueForKeyPath:@"id"];

  if ( [id isEqualToString:kLastSectionID] )  {

    Stop *stop = (Stop *)[[self lastViewed] valueForKey:@"stop"];
    StopTimesTableViewController *target = [[StopTimesTableViewController alloc] init];
    [target setSelectedStop:stop];
    [target setSelectedRoute:[stop route]];
    
    [[self navigationController] pushViewController:target animated:YES];

  } else if ( [id isEqualToString:kStopSectionID] )  {

    Stop *stop = (Stop *)[[self stopsDisplayed] objectAtIndex:[indexPath row]];
    StopTimesTableViewController *target = [[StopTimesTableViewController alloc] init];
    [target setSelectedStop:stop];
    [target setSelectedRoute:[stop route]];

    [[self navigationController] pushViewController:target animated:YES];
  }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
  [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:[self tableView]];
}

- (void) dealloc {

  [_stopsDB dealloc];
  [_stopsDisplayed dealloc];
  [_routes dealloc];
  [_lastViewed dealloc];
  [_myLocation dealloc];
  [_dataArraysForRoutesScreen dealloc];
  [_locationManager dealloc];
  [_refreshTimer dealloc];
  
  [super dealloc];
 
}

@end