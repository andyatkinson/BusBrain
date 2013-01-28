//
//  TripViewController.m
//  BusBrain
//
//  Created by John Doll on 1/6/13.
//
//

#import "BusBrainAppDelegate.h"
#import "TripViewController.h"
#import "TripCell.h"
#import "Trip.h"
#import "StopTimesTableViewController.h"
#import "NoStops.h"

@implementation TripViewController

@synthesize trips = _trips;
@synthesize stop   = _stop;

- (void) viewWillAppear:(BOOL)animated {
  BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
  [app saveAnalytics:@"TripTableView"];
}

- (id)initWithStyle:(UITableViewStyle)style{
  self = [super initWithStyle:style];
  if (self) {
    
  }
  return self;
}

- (void) loadTripsForStop:(Stop*) stop {
  [self setStop:stop];
  
  [[self navigationItem] setTitle: @"Route Direction"];
  
  [self showHUD];
  [stop loadTrips:^(NSArray *records) {
    [self setTrips:records];
    [[self HUD] hide:YES];
    [[self tableView] reloadData];
    
    if([records count] == 0){
      BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
      [app saveAnalytics:[NSString stringWithFormat:@"TripTableView/%@/NoTrips", [stop stop_id]]];
    }
  }];
}

- (void) backButtonPressed:(id)sender {
  UINavigationController *navController = self.navigationController;
  [navController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  //Setup View
  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [backButton setFrame:CGRectMake(0.0f, 0.0f, 35.0f, 30.0f)];
  [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [backButton setImage:[UIImage imageNamed:@"btn_back_norm.png"] forState:UIControlStateNormal];
  [backButton setImage:[UIImage imageNamed:@"btn_back_down.png"] forState:UIControlStateHighlighted];
  [backButton setImage:[UIImage imageNamed:@"btn_back_down.png"] forState:UIControlStateSelected];
  
  UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  self.navigationItem.leftBarButtonItem = backBarButtonItem;
  
  [self setTableView:[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)]];
  
  [super viewDidLoad];
  
  [[self tableView] setDataSource: self];
  [[self tableView] setDelegate: self];
  [[self tableView] setSeparatorStyle: UITableViewCellSeparatorStyleNone];
  [[self tableView] setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]]];
  [self setView:[self tableView]];
  
  
  
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 57;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if([[self trips] count] > 0){
    return [[self trips] count];
  }
  
  if([[self HUD] alpha] < 1){
    return 1;
  }
  return 0;
}


- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  
  if ([[self trips] count] > 0) {
    TripCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[TripCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryView:[[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    Trip *trip = [[self trips] objectAtIndex:[indexPath row]];
    [cell setTrip:trip];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
  } else {
    static NSString *CellIdentifier = @"NoStops";
    NoStops* cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[NoStops alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [[cell message] setText:@"No Active Buses on this Route"];
    return cell;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if ([[self trips] count] > 0) {
    Trip *trip = [[self trips] objectAtIndex:[indexPath row]];
    [[self stop] setTrip:trip];

    StopTimesTableViewController *target = [[StopTimesTableViewController alloc] init];
    [target setSelectedStop:[self stop]];
    [[self navigationController] pushViewController:target animated:YES];
  }
  
}

@end
