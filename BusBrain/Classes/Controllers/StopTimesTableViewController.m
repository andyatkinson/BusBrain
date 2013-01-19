//
//  StopTimesTableViewController.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "MainTableViewController.h"
#import "StopTimesTableViewController.h"
#import "CountDownCell.h"
#import "StopTimeCell.h"
#import "StopTime.h"
#import "NSString+BeetleFight.h"
#import "FunnyPhrase.h"
#import "BusBrainAppDelegate.h"
#import "NSDate+BusBrain.h"

@implementation StopTimesTableViewController

@synthesize countDownCell = _countDownCell;
@synthesize stopTimes     = _stopTimes;
@synthesize stopHours     = _stopHours;
@synthesize stopData      = _stopData;
@synthesize selectedStop  = _selectedStop;
@synthesize refreshTimer  = _refreshTimer;

- (void) viewWillAppear:(BOOL)animated {
  BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
  [app saveAnalytics:@"StopTimesTableView"];
}

- (void) viewWillDisappear:(BOOL)animated {
  [[self refreshTimer] invalidate];
  [self setRefreshTimer: nil];
  
  [[self countDownCell] stopTimer];
}

- (id)initWithStyle:(UITableViewStyle)style{
  self = [super initWithStyle:style];
  if (self) {

  }
  return self;
}

- (void) setupRefresh {

  if ( [self refreshTimer] != (id)[NSNull null] ) {
    StopTime *stop_time = (StopTime *)[[self stopTimes] objectAtIndex:0];
    NSArray  *departureData = [stop_time getTimeTillDeparture];
    NSNumber *seconds = (NSNumber*) [departureData objectAtIndex:3];

    int interval = 0;
    if( [seconds intValue] < 30 ) {
      interval = 30 + [seconds intValue];
    } else if ([seconds intValue] > 30 ) {
      interval = [seconds intValue] - 30;
    }

    [self setRefreshTimer: [NSTimer scheduledTimerWithTimeInterval:interval
                            target:self
                            selector:@selector(refeshTable)
                            userInfo:nil
                            repeats:NO]];
  }
}

- (void) refeshTable {
  StopTime *stop_time = (StopTime *)[[self stopTimes] objectAtIndex:0];
  NSArray  *departureData = [stop_time getTimeTillDeparture];
  NSNumber *timeTillDeparture = (NSNumber*) [departureData objectAtIndex:0];
  
  if ([timeTillDeparture intValue] == 0) {
    [self loadStopTimes];
  } else {
    [[self tableView] reloadData];
    [self loadNextTrip];
  }

  [self setRefreshTimer: [NSTimer scheduledTimerWithTimeInterval:60
                          target:self
                          selector:@selector(refeshTable)
                          userInfo:nil
                          repeats:NO]];

}

- (void) processStopTimes {
  NSEnumerator *e = [[self stopTimes] objectEnumerator];
  StopTime *thisTime;
  
  [self setStopHours: [[NSMutableArray alloc] init]];
  [self setStopData: [[NSMutableDictionary alloc] init]];
  
  while (thisTime = (StopTime*) [e nextObject]) {
    NSDate *stopDate = [thisTime getStopDate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //[calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit) fromDate:stopDate];
    NSInteger stopDay    = [components day];
    
    components = [calendar components:(NSDayCalendarUnit) fromDate:[NSDate timeRightNow]];
    NSInteger currentDay  = [components day];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(currentDay == stopDay){
      [dateFormatter setDateFormat:@"h a"];
    } else {
      [dateFormatter setDateFormat:@"EEEE h a"];
    }
    
    NSString *stopHour = [dateFormatter stringFromDate:stopDate];
    
    
    //Use this array to keep track of the desired order
    if(! [[self stopHours] containsObject:stopHour]){
      [[self stopHours] addObject:stopHour];
    }
    
    //Use the Dictionary to group stops by hour
    NSMutableArray *stopsForHour = [[self stopData] objectForKey:stopHour];
    if( stopsForHour == nil){
      stopsForHour = [[NSMutableArray alloc] init];
      [[self stopData] setObject:stopsForHour forKey:stopHour];
    }
    [stopsForHour addObject:thisTime];
    
  }
}

- (void) loadNextTrip {
  [[self selectedStop] loadNextTripTimes:^(BOOL success) {
    
    if(success){
      //Update UI
      if([[[self selectedStop] nextTripStopTimes] count] == 0){
        [[self countDownCell] setNexTrip: @""];
      } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        
        
        [[self countDownCell] setFormatedTime: [dateFormatter stringFromDate:[[[[self selectedStop] nextTripStopTimes] objectAtIndex:0] getStopDate] ]];
        [[self countDownCell] setStopTime:[[[self selectedStop] nextTripStopTimes] objectAtIndex:0]];
        [[self countDownCell] setNexTrip: @"NexTrip"];
      }
      
      
    } else {
      //Do we care?
    }
  }];
  
}

- (void) loadStopTimes {
  

  if ([self selectedStop] == NULL || [[[self selectedStop] route] short_name] == 0) {
    NSLog(@"tried to call controller but didn't supply enough data. <selectedStop>: %@", [self selectedStop]);

  } else {

    [self showHUD];
    [[self selectedStop] loadStopTimes:^(NSArray *stops) {
                          
       [self setStopTimes: stops];
       [self processStopTimes];

       if ([[self stopTimes] count] > 0) {
         StopTime *stop_time = (StopTime *)[[self stopTimes] objectAtIndex:0];
         [[self countDownCell] setStopTime:stop_time];

         [self setupRefresh];
         [[self tableView] reloadData];
         
         [self loadNextTrip];
         
       } else {
         UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,400)];
         container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
         UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,5,self.view.frame.size.width, 50)];
         label.backgroundColor = [UIColor clearColor];
         label.textAlignment = UITextAlignmentLeft;
         label.textColor = [UIColor whiteColor];
         label.text = @"No upcoming departures. Check later.";
         label.font = [UIFont boldSystemFontOfSize:14.0];
         [container addSubview:label];
         self.view = container;
       }

                          
       NSMutableDictionary *lastViewed = [[NSMutableDictionary alloc] init];
       [lastViewed setValue:[self selectedStop] forKey:@"stop"];
                          
       BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
       [[app mainTableViewController] setLastViewed:lastViewed];
                          
       NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
       [settings setObject:[[self selectedStop] stop_id] forKey:@"last_viewed_stop_id"];
       [settings synchronize];

       [[self tableView] reloadRowsAtIndexPaths:[[self tableView] indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
       [[self HUD] hide:YES];

     }];

  }


}

- (void) backButtonPressed:(id)sender {
  UINavigationController *navController = self.navigationController;
  [navController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [backButton setFrame:CGRectMake(0.0f, 0.0f, 35.0f, 30.0f)];
  [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [backButton setImage:[UIImage imageNamed:@"btn_back_norm.png"] forState:UIControlStateNormal];
  [backButton setImage:[UIImage imageNamed:@"btn_back_down.png"] forState:UIControlStateHighlighted];
  [backButton setImage:[UIImage imageNamed:@"btn_back_down.png"] forState:UIControlStateSelected];
  
  UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  self.navigationItem.leftBarButtonItem = backBarButtonItem;
  
  [self setTableView:[[UITableView alloc] initWithFrame:CGRectMake(22, 207, 270, 233)]];
  
  [super viewDidLoad];
  
  [[self tableView] setDataSource: self];
  [[self tableView] setDelegate: self];
  
  [self setData: [[NSMutableArray alloc] init]];
  
  [self setStopTimes: [[NSArray alloc] init]];
  [self loadStopTimes];
  
  [[self tableView] setSeparatorStyle: UITableViewCellSeparatorStyleNone];
  [[self tableView] setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]]];
  
  
  [[self navigationItem] setTitle: [[self selectedStop] stop_name]];
  
  [self setView: [self tableView]];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[[self stopData] allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  
  if([[[self stopData] allKeys] count] == 1){
    return @"Upcoming Departures";
  } else {
    return [[self stopHours] objectAtIndex:section - 1];
  }
  
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([indexPath section] == 0) {
    return 154;
  }
  return 57;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return 0;
  } else if (section > 0) {
    return 28;
  }
  
  return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 1;
  } else if (section > 0) {
    NSString *stopHour = [[self stopHours] objectAtIndex:section - 1];
    return [(NSMutableArray*)[[self stopData] objectForKey:stopHour] count];
  }
  
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  
  if ([[self stopTimes] count] > 0) {
    if ([indexPath section] == 0) {
      
      if ([self countDownCell] == NULL) {
        [self setCountDownCell:[[CountDownCell alloc] init]];
        
        StopTime *stop_time = (StopTime *)[[self stopTimes] objectAtIndex:[indexPath row]];
        [[self countDownCell] setStop:[self selectedStop]];
        [[self countDownCell] setStopTime:stop_time];
      }
      return [self countDownCell];
      
      
    } else if ([indexPath section] > 0) {
      
      StopTimeCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
        cell = [[StopTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      }
      
      NSString *stopHour = [[self stopHours] objectAtIndex:[indexPath section] - 1];
      StopTime *stop_time = (StopTime *)[ (NSMutableArray*)[[self stopData] objectForKey:stopHour] objectAtIndex:[indexPath row]];
      
      [[cell icon] setImage: [UIImage imageNamed:@"icon_clock.png"]];
      [cell setStopTime:stop_time];
      [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
      
      return cell;
      
    }
  }
  
  return cell;
}

@end