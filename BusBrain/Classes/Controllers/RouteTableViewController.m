//
//  RouteTableViewController.m
//  BusBrain
//
//  Created by John Doll on 1/5/13.
//
//

#import "BusBrainAppDelegate.h"
#import "RouteTableViewController.h"
#import "TripViewController.h"
#import "StopViewController.h"
#import "Route.h"
#import "RouteCell.h"

@implementation RouteTableViewController

@synthesize routes = _routes;
@synthesize stop   = _stop;

- (void) viewWillAppear:(BOOL)animated {
  BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
  [app saveAnalytics:@"RouteTableView"];
}

- (id)initWithStyle:(UITableViewStyle)style{
  self = [super initWithStyle:style];
  if (self) {
    
  }
  return self;
}

- (void) loadRoutesForStop:(Stop*) stop {
  [self setStop:stop];
  [[self navigationItem] setTitle: [NSString stringWithFormat:@"%@", stop.stop_name ] ];
  
  [self showHUD];
  [stop loadRoutes:^(NSArray *records) {
    [self setRoutes:records];
    [[self HUD] hide:YES];
    [[self tableView] reloadData];
    
    if([records count] == 0){
      BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
      [app saveAnalytics:[NSString stringWithFormat:@"RouteTableView/%@/NoRoutes", [stop stop_id]]];
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
  //[[self navigationItem] setTitle: @"Routes"];

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
  if([[self routes] count] > 0){
    return 1;
  } else {
    return 0;
  }
  
  return 0;
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
  return [[self routes] count];

}


- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  
  if ([[self routes] count] > 0) {
    RouteCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryView:[[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    Route *route = [[self routes] objectAtIndex:[indexPath row]];
    [cell setRoute:route];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  Route *route = [[self routes] objectAtIndex:[indexPath row]];
  if([self stop] == nil){
    StopViewController *target = [[StopViewController alloc] init];
    [target loadStopsForRoute:route];
    [[self navigationController] pushViewController:target animated:YES];

  } else {
    [[self stop] setRoute:route];
    TripViewController *target = [[TripViewController alloc] init];
    [target loadTripsForStop:[self stop]];
    [[self navigationController] pushViewController:target animated:YES];
  }
  
}

@end
