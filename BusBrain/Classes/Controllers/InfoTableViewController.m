//
//  InfoTableViewController.m
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "InfoTableViewController.h"
#import "BusBrainAppDelegate.h"

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

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
  [app saveAnalytics:@"InfoTableView"];
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

  NSArray *metroTransit = [NSArray arrayWithObjects:@"Call Metro Transit", nil];
  NSArray *support = [NSArray arrayWithObjects:@"Email the team", nil];

  [self.dataArrays addObject:metroTransit];
  [self.dataArrays addObject:support];

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
    return @"Metro Transit";
  } else if (section == 1) {
    return @"Application Support";
  }
  return NULL;
}

-(int) numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 1;
  } else if (section == 1) {
    return 1;
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
  
  int rowsInSection = [self numberOfRowsInSection:indexPath.section];
  if(rowsInSection == 1){
    return 46;
  } else {
      if (indexPath.row == 0) {
        return 46;
      } else if (indexPath.row == rowsInSection - 1) {
        return 46;
      } else {
        return 43;
      }
  }
  
  return 0;
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
    
    /* this doesn't preserve the rounded corners of the grouped tableviewcell style
     - If it can be clicked and set to black and preserve the rounded corners, then feel free to kill the selectionStyle above
     
    UIView *selectHighlightView = [[UIView alloc] init];
    [selectHighlightView setBackgroundColor:[UIColor ]];
    [cell setSelectedBackgroundView: selectHighlightView];
     */
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      // call metro transit
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://612-373-3333"]];
    }
  } else if (indexPath.section == 1) {
    
    if (indexPath.row == 0) {
      [self composeEmail:@"beetlefight@gmail.com"];
    }
  }
}

- (void)composeEmail:(NSString *)emailAddr {
  
  if ([MFMailComposeViewController canSendMail]) {
    NSArray *recipients = [[NSArray alloc] initWithObjects:emailAddr, nil];
    
    NSString *emailBody = @"<br/><br/>Download Train Brain for iOS and follow <a href='http://twitter.com/trainbrainapp'>@trainbrainapp</a> on twitter";
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setToRecipients:recipients];
    [mailViewController setSubject:@"Message from bus brain"];
    [mailViewController setMessageBody:emailBody isHTML:YES];
    [[mailViewController navigationBar] setTintColor:[UIColor blackColor]];
    
    [self presentModalViewController:mailViewController animated:YES];
    [mailViewController release];
    [recipients release];
    [emailBody release];
    
  } else {
    // pop an UIAlertView?
    NSLog(@"can't send email");
  }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
  [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
  [tableView dealloc];
  [dataArrays dealloc];
  
  [super dealloc];
}

@end
