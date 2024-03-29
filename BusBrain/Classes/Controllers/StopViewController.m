//
//  StopViewController.m
//  BusBrain
//
//  Created by John Doll on 1/6/13.
//
//

#import "BusBrainAppDelegate.h"
#import "StopViewController.h"
#import "StopCell.h"
#import "Stop.h"
#import "RouteTableViewController.h"
#import "TripViewController.h"
#import "NoStops.h"

@implementation StopViewController

@synthesize stops = _stops;
@synthesize route = _route;

- (void) viewWillAppear:(BOOL)animated {
  BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
  [app saveAnalytics:@"StopTableView"];
}

- (id)initWithStyle:(UITableViewStyle)style{
  self = [super initWithStyle:style];
  if (self) {
    
  }
  return self;
}

- (void) loadStopsForRoute:(Route*) route {
  [self setRoute:route];
  
  //Set Title
  [[self navigationItem] setTitle: [NSString stringWithFormat:@"Stops for Route: %i", [route short_name]]];

  [self showHUD];

  [Stop loadStopsforRoute:route block:^(NSArray *records) {
    [self setStops:records];
    [[self HUD] hide:YES];
    [[self tableView] reloadData];
    
    if([records count] == 0){
      BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
      [app saveAnalytics:[NSString stringWithFormat:@"StopTableView/%i/NoStops", [route short_name]]];
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
  
  
  //Set Title
  //[[self navigationItem] setTitle: @"Stops"];
  
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
  if ([[self stops] count] > 0) {
    return [[self stops] count];
  }
  
  if([[self HUD] alpha] < 1){
    return 1;
  }
  
  return 0;
}


- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell =nil;
  
  if ([[self stops] count] > 0) {
    StopCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[StopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryView:[[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    Stop *stop = [[self stops] objectAtIndex:[indexPath row]];
    [stop setRoute:[self route]];
    [cell setStop:stop];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
  }  else {
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
  
  if ([[self stops] count] > 0) {
    Stop *stop = [[self stops] objectAtIndex:[indexPath row]];
    if([self route] == nil){
      RouteTableViewController *target = [[RouteTableViewController alloc] init];
      [target loadRoutesForStop:stop];
      [[self navigationController] pushViewController:target animated:YES];
    } else {
      TripViewController *target = [[TripViewController alloc] init];
      [target loadTripsForStop:stop];
      [[self navigationController] pushViewController:target animated:YES];
    }
  }

}

@end
