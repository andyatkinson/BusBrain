//
//  StopTimesTableViewController.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "MainTableViewController.h"
#import "StopTimesTableViewController.h"
#import "BigDepartureTableViewCell.h"
#import "StopTimeCell.h"
#import "StopTime.h"
#import "NSString+BeetleFight.h"
#import "FunnyPhrase.h"
#import "BusBrainAppDelegate.h"

@implementation StopTimesTableViewController

@synthesize bigCell       = _bigCell;
@synthesize data          = _data;
@synthesize stopTimes     = _stopTimes;
@synthesize selectedStop  = _selectedStop;
@synthesize refreshTimer  = _refreshTimer;

- (void) viewWillAppear:(BOOL)animated {
  BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
  [app saveAnalytics:@"StopTimesTableView"];
}

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
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
  }

  [self setRefreshTimer: [NSTimer scheduledTimerWithTimeInterval:60
                          target:self
                          selector:@selector(refeshTable)
                          userInfo:nil
                          repeats:NO]];

}

- (void)loadStopTimes {
  

  if ([self selectedStop] == NULL || [[[self selectedStop] route] route_id] == NULL) {
    NSLog(@"tried to call controller but didn't supply enough data. <selectedStop>: %@", [self selectedStop]);

  } else {

    [self showHUD];
    
    [StopTime stopTimesSimple:[[[self selectedStop] route] route_id]
                         stop:[[self selectedStop] stop_id]
                         near:nil  
                        block:^(NSArray *stops) {
                          
       [self setStopTimes: stops];

       if ([[self stopTimes] count] > 0) {
         StopTime *stop_time = (StopTime *)[[self stopTimes] objectAtIndex:0];
         [[self bigCell] setStopTime:stop_time];

         [self setupRefresh];
         [[self tableView] reloadData];
       } else {
         UIView *container = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,400)] autorelease];
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
       [[self main] setLastViewed:lastViewed];
                          
       NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
       [settings setObject:[[self selectedStop] stop_id] forKey:@"last_viewed_stop_id"];
       [settings synchronize];

       [[self tableView] reloadRowsAtIndexPaths:[[self tableView] indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
       [[self HUD] hide:YES];

     }];

  }


}

- (void)viewDidLoad {

  UIImage *backButton = [[UIImage imageNamed:@"btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
  [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
  
  UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
  [[self navigationItem] setBackBarButtonItem: backBarButton];
  [backBarButton release];

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

- (void) viewDidDisappear:(BOOL)animated{
  [[[self main] tableView] reloadData];
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
  return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  
  if(section == 1) {
    return @"Upcoming Departures";
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
  } else if (section == 1) {
    return 28;
  }
  else {
    // error case
    return 0;
  }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == 0) {
    return 1;
  } else if (section == 1) {
    return [[self stopTimes] count];
  } else {
    // error
    return 0;
  }

}


- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [[UITableViewCell alloc] init];

  if ([[self stopTimes] count] > 0) {
    if ([indexPath section] == 0) {

      if ([self bigCell] == NULL) {
        [self setBigCell:[[BigDepartureTableViewCell alloc] init]];

        StopTime *stop_time = (StopTime *)[[self stopTimes] objectAtIndex:[indexPath row]];
        [[self bigCell] setStopTime:stop_time];
        [[[self bigCell] funnySaying] setText: [FunnyPhrase rand]];
        [[[self bigCell] description] setText: [[[self selectedStop] headsign] headsign_name] ];

        [[self bigCell] startTimer];
      }
      return [self bigCell];


    } else if ([indexPath section] == 1) {

      StopTimeCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
        cell = [[[StopTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      }
      
      StopTime *stop_time = (StopTime *)[[self stopTimes] objectAtIndex:[indexPath row]];
      [[cell icon] setImage: [UIImage imageNamed:@"icon_clock.png"]];
      [cell setStopTime:stop_time];
      [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

      return cell;

    }
  }

  return cell;
}

- (void)dealloc {
  [_data dealloc];
  [_selectedStop dealloc];
  [_stopTimes dealloc];
  [_bigCell dealloc];
  [_refreshTimer dealloc];
  
  [super dealloc];
 
}

@end