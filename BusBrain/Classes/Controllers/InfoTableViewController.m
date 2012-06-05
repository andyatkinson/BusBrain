//
//  InfoTableViewController.m
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "InfoTableViewController.h"

@implementation InfoTableViewController

@synthesize dataArrays, tableView;

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {

  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.frame.size.width,29)] autorelease];

  UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
  headerLabel.textAlignment = UITextAlignmentLeft;

  // FIXME, how do I get this from the delegate method instead?
  if (section == 0) {
    headerLabel.text = @"General Information";
  } else if (section == 1) {
    headerLabel.text = @"Support";
  } else if (section == 2) {
    headerLabel.text = @"Metro Transit";
  }

  headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
  headerLabel.textColor = [UIColor grayColor];
  headerLabel.backgroundColor = [UIColor clearColor];
  [headerView addSubview:headerLabel];

  [headerView addSubview:headerLabel];

  [headerLabel release];

  return headerView;
}

- (void)viewDidLoad {

  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];

  [super viewDidLoad];

  self.tableView.delegate = self;
  self.tableView.dataSource = self;


  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];

  //Initialize the array.
  dataArrays = [[NSMutableArray alloc] init];

  NSArray *general = [NSArray arrayWithObjects:@"Hiawatha Light Rail Line", @"Northstar Commuter Line", nil];
  NSArray *support = [NSArray arrayWithObjects:@"Contact Us", @"Feedback", @"Credits", nil];
  NSArray *metroTransit = [NSArray arrayWithObjects:@"Call", @"Feedback", nil];

  [self.dataArrays addObject:general];
  [self.dataArrays addObject:support];
  [self.dataArrays addObject:metroTransit];

  //Set the title
  self.navigationItem.title = @"Information";

  self.view = self.tableView;
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  if (section == 0) {
    return 0;
  } else if (section == 1) {
    return 3;
  } else if (section == 2) {
    return 2;
  } else {
    // should not reach here
    return 0;
  }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

  if (section == 0) {
    return @"General Information";
  } else if (section == 1) {
    return @"Support";
  } else if (section == 2) {
    return @"Metro Transit";
  }
  return NULL;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 3;   // [self.dataArrays count]
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }


  cell.textLabel.text = [[self.dataArrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];


  return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {


    }

  }
}

- (void)dealloc {
  [tableView dealloc];
  [dataArrays dealloc];
  
  [super dealloc];
}

@end
