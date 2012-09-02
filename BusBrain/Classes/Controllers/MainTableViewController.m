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

#import "TransitAPIClient.h"
#import "AFJSONRequestOperation.h"

NSString * const kStopSectionID   = @"STOP";
NSString * const kLastSectionID   = @"LAST";

@implementation MainTableViewController

@synthesize dataArraysForRoutesScreen = _dataArraysForRoutesScreen;
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
  //[self loadDataForLocation:[self myLocation]];
}

- (void) hideHUD {
  if([self fetchCount] == 0) {
    [[self HUD] hide:YES];
  }
}

- (void) loadStopsForLocation:(CLLocation *)location {
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  if (location) {
		[params setValue:[NSString stringWithFormat:@"%1.7f", location.coordinate.latitude] forKey:@"lat"];
		[params setValue:[NSString stringWithFormat:@"%1.7f", location.coordinate.longitude] forKey:@"lon"];
	}

  [Stop loadNearbyStops:@"bus/v1/stops/nearby" near:location parameters:params block:^(NSDictionary *data) {
    
    if (data == NULL || ![data isKindOfClass:[NSDictionary class]]) {
      UIView *container = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,400)] autorelease];
      container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,5,self.view.frame.size.width, 50)];
      label.backgroundColor = [UIColor clearColor];
      label.textAlignment = UITextAlignmentLeft;
      label.textColor = [UIColor whiteColor];
      label.text = @"Error loading data. Please email support.";
      label.font = [UIFont boldSystemFontOfSize:14.0];
      [container addSubview:label];
      self.view = container;

      
    } else {
      
      self.stops = [data objectForKey:@"stops"];
      [self.tableView reloadData];
      [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];

    }
    
   [self setFetchCount: [self fetchCount] - 1];
   [self hideHUD];
  }];
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

  //Since we are kicking off multiple requests that could come back in a different order
  //We need to keep track of it and each caller needs to decreemnt the fetchCount and
  //call hideHUD
  [self setFetchCount: 1];
  [self loadStopsForLocation:location];
  //[self loadLastViewedStop];

}

- (BOOL) isCacheStail{
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

  int lastCacheStamp = [settings integerForKey:@"lastCacheStamp"];
  NSDate *lastCacheDate = [NSDate dateWithTimeIntervalSince1970:lastCacheStamp];
  NSDate *now = [NSDate date];

  NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
  NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                             fromDate:lastCacheDate
                                               toDate:now
                                              options:0];
  
  if(components.day > 0 || components.hour > 20){
    return true;
  } else {
    return false;
  }

}

- (void) purgeCachedData {
#ifdef DEBUG_BB
  NSLog(@"Cache Dumped");
#endif
  [self setStopsDB:nil];
}

-(void) cacheStopDB:(id <BusProgressDelegate>)delegate {
  [self setCacheLoaded:false];

  //Kick off download of new cache
  if([self isCacheStail]){
    [self downloadCache:delegate];
  }
  
  //Load existing cache
  [Stop loadStopsDB:^(NSArray *db) {
    [self setStopsDB:db];
    [self setCacheLoaded:true];
  }];
  
}

- (void) initData:(id <BusProgressDelegate>)delegate {
  [self cacheStopDB:delegate];
  
  Stop *s1 = [[Stop alloc] initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Loading...", @"stop_desc", nil]];
  [self setStops:[NSArray arrayWithObjects:s1, nil]];

  
  NSDictionary *lastStopIDDict = [NSDictionary dictionaryWithObject:kLastSectionID forKey:@"id"];
  NSDictionary *stopsDict      = [NSDictionary dictionaryWithObject:kStopSectionID forKey:@"id"];

  [self setDataArraysForRoutesScreen: [[NSMutableArray alloc] init]];

  [[self dataArraysForRoutesScreen] addObject:stopsDict];
  [[self dataArraysForRoutesScreen] addObject:lastStopIDDict];
  
  //[self setLastViewed:[[NSMutableDictionary alloc] init]];

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
      [alert release];
      
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
   
  //[[self navigationController] pushViewController:target animated:NO];
  
  [UIView beginAnimations:@"View Flip" context:nil];
  [UIView setAnimationDuration:0.70];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  
  [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];

  [self.navigationController pushViewController:target animated:YES];
  [UIView commitAnimations];
  
}

- (void) downloadCache:(id <BusProgressDelegate>)delegate {
#ifdef DEBUG_BB
  NSLog(@"Cache Download Started");
#endif
  
  NSMutableURLRequest *afRequest = [[TransitAPIClient sharedClient]      
                                    requestWithMethod:@"GET"
                                    path:@"/bus/v1/stops"  
                                    parameters:nil]; 
  
  AFHTTPRequestOperation *operation = [[TransitAPIClient sharedClient] HTTPRequestOperationWithRequest:afRequest 
                         success:^(AFHTTPRequestOperation *operation, id JSON) {
                           NSMutableArray *stopRecords = [NSMutableArray array];
                           NSMutableArray *dictRecords  = [NSMutableArray array];
                           for (NSDictionary *attributes in [JSON valueForKeyPath:@"stops"]) {
                             Stop *stop = [[[Stop alloc] initWithAttributes:attributes] autorelease];
                             [stopRecords addObject:stop];
                             [dictRecords addObject:attributes];
                           }
#ifdef DEBUG_BB
  NSLog(@"Cache Download Complete");
#endif
                           NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
                           [settings setInteger:[[NSDate date] timeIntervalSince1970] forKey:@"lastCacheStamp"];
                           
                           //[self setStopsDB:stopRecords];
                           [delegate dismiss];
                           
                           NSError* error = nil;
                           NSFileManager *fileMgr = [NSFileManager defaultManager];
                           NSString *documentsDirectory = [NSHomeDirectory() 
                                                           stringByAppendingPathComponent:@"Documents"];
                           NSString *downloadPath = [documentsDirectory 
                                                 stringByAppendingPathComponent:@"Download.plist"];
                           
                           if(![dictRecords writeToFile:downloadPath atomically:NO]) {
                             NSLog(@"Array wasn't saved properly");
                           };
                           
                           NSString *copyPath = [documentsDirectory 
                                                     stringByAppendingPathComponent:@"DownloadStops.plist"];
                           if ([fileMgr removeItemAtPath:copyPath error:&error] != YES) {
                             NSLog(@"Unable to delete file: %@", [error localizedDescription]);
                           }
                           
                           if(![fileMgr copyItemAtPath:downloadPath 
                                                toPath:copyPath
                                                 error:&error]){
                             NSLog(@"Failed to Copy");
                             NSLog(@"Error description-%@ \n", [error localizedDescription]);
                             NSLog(@"Error reason-%@", [error localizedFailureReason]);
                           }
                           
                         } 
                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"Failed: %@",[error localizedDescription]);     
                         }];
  
  [operation setDownloadProgressBlock:^(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
    float progress = ((float)((int)totalBytesRead) / (float)((int)totalBytesExpectedToRead));
    [delegate setProgress:progress];
  }];
  
  [[TransitAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
  
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

  
  [self initPullRefresh];
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
    return [[self stops] count];
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

    Stop *stop = (Stop *)[[self stops] objectAtIndex:[indexPath row]];
    
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
    //[target setSelectedRoute:[stop route]];
    
    [[self navigationController] pushViewController:target animated:YES];

  } else if ( [id isEqualToString:kStopSectionID] )  {

    Stop *stop = (Stop *)[[self stops] objectAtIndex:[indexPath row]];
    StopTimesTableViewController *target = [[StopTimesTableViewController alloc] init];
    [target setSelectedStop:stop];
    //[target setSelectedRoute:[stop route]];

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
  [_stops dealloc];
  [_lastViewed dealloc];
  [_myLocation dealloc];
  [_dataArraysForRoutesScreen dealloc];
  [_locationManager dealloc];
  [_refreshTimer dealloc];
  
  [super dealloc];
 
}

@end