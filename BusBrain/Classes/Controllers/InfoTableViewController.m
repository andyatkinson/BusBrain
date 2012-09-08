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

- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.frame.size.width,29)] autorelease];
  
  UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
  headerLabel.textAlignment = UITextAlignmentLeft;
  headerLabel.text = [self tableView:tv titleForHeaderInSection:section];
  headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
  headerLabel.textColor = [UIColor grayColor];
  headerLabel.backgroundColor = [UIColor clearColor];
  [headerView addSubview:headerLabel];
  [headerLabel release];
  
  return headerView;
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

-(int) numberOfRowsInSection:(NSInteger)section {
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return [self numberOfRowsInSection:section];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  if ([self.dataArrays count] > 0) {
    return [self.dataArrays count];
  } else {
    return 0;
  }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.shadowColor = [UIColor blackColor];
    cell.textLabel.shadowOffset = CGSizeMake(0,-1);
    
  }
  
  int rowsInSection = [self numberOfRowsInSection:indexPath.section];
  if(rowsInSection == 1){
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"info_cell_single.png"]
                                                              resizableImageWithCapInsets:UIEdgeInsetsZero]];
  } else {
    cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]];
    if (indexPath.row == 0) {
      cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"info_cell_top.png"]
                                                                resizableImageWithCapInsets:UIEdgeInsetsZero]];
    } else if (indexPath.row == rowsInSection - 1) {
      cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"info_cell_bottom.png"]
                                                                resizableImageWithCapInsets:UIEdgeInsetsZero]];
    } else {
      cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"info_cell_middle.png"]
                                                                resizableImageWithCapInsets:UIEdgeInsetsZero]];
    }
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
