//
//  InfoTableViewController.m
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "InfoTableViewController.h"
#import "BusBrainAppDelegate.h"

@implementation InfoTableViewController

@synthesize dataArrays = _dataArrays;
@synthesize tableView  = _tableView;
@synthesize hud        = _hud;

- (id)init {
  self = [super init];
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
  self.tableView = [[UITableView alloc] init];
  self.tableView.frame = CGRectMake(10, 0, self.view.bounds.size.width - 20, self.view.bounds.size.height);
  self.tableView.scrollEnabled = YES;
  
  [super viewDidLoad];
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [[self tableView] setBackgroundColor:[UIColor clearColor]];

  //Initialize the array.
  _dataArrays = [[NSMutableArray alloc] init];

  NSArray *metroTransit = [NSArray arrayWithObjects:@"Call Metro Transit", nil];
  NSArray *support      = [NSArray arrayWithObjects:@"Email the team", @"Refresh stop and route data", nil];
  NSArray *emailShare   = [NSArray arrayWithObjects:@"Tell your friends", nil];

  [self.dataArrays addObject:metroTransit];
  [self.dataArrays addObject:support];
  [self.dataArrays addObject:emailShare];

  //Set the title
  self.navigationItem.title = @"Information";

  [[self view] addSubview:[self tableView]];
  
  _hud = [[MBProgressHUD alloc] initWithView:[self view]];
  [[self view] addSubview:_hud];
  [_hud setDelegate: self];
  [_hud setLabelText:@"Loading"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.frame.size.width,29)];
  
  UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
  headerLabel.textAlignment = UITextAlignmentLeft;
  headerLabel.text = [self tableView:tv titleForHeaderInSection:section];
  headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
  headerLabel.textColor = [UIColor grayColor];
  headerLabel.backgroundColor = [UIColor clearColor];
  [headerView addSubview:headerLabel];
  
  return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
    return @"Metro Transit";
  } else if (section == 1) {
    return @"Get Help";
  } else if (section == 2) {
    return @"Share";
  }
  return NULL;
}

-(int) numberOfRowsInSection:(NSInteger)section {
  return [[[self dataArrays] objectAtIndex:section] count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return [self numberOfRowsInSection:section];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if ([self.dataArrays count] > 0) {
    return [self.dataArrays count];
  } else {
    return 0;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  int rowsInSection = [self numberOfRowsInSection:indexPath.section];
  if (rowsInSection == 1){
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
  UITableViewCell *cell;
  
  if(indexPath.section == 1 && indexPath.row == 1){
    static NSString *CellIdentifier = @"SubCell";
    cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    int lastCacheStamp = [settings integerForKey:@"lastCacheStamp"];
    NSDate *lastCacheDate = [NSDate dateWithTimeIntervalSince1970:lastCacheStamp];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd yyyy"];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Last refreshed: %@", [dateFormat stringFromDate:lastCacheDate]];
  } else {
    static NSString *CellIdentifier = @"Cell";
    cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }

  cell.backgroundColor = [UIColor clearColor];
  cell.textLabel.textColor = [UIColor whiteColor];
  cell.detailTextLabel.textColor = [UIColor grayColor];
  
  cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
  cell.textLabel.shadowColor = [UIColor blackColor];
  cell.textLabel.shadowOffset = CGSizeMake(0,-1);
  

  
  cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]];
  if(indexPath.section == 1 && indexPath.row == 1){
    cell.accessoryView = nil;
  }
  
  int rowsInSection = [self numberOfRowsInSection:indexPath.section];
  if (rowsInSection == 1){
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"info_cell_single.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
  } else {
    
    if (indexPath.row == 0) {
      cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"info_cell_top.png"]
                                                                resizableImageWithCapInsets:UIEdgeInsetsZero]];
    } else if (indexPath.row == 1 || indexPath.row == 2) {
      cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"info_cell_bottom.png"]
                                                                resizableImageWithCapInsets:UIEdgeInsetsZero]];
    } else {
      cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"info_cell_middle.png"]
                                                                resizableImageWithCapInsets:UIEdgeInsetsZero]];
    }
  }
  
  cell.textLabel.text = [[self.dataArrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
  UIView *selectHighlightView = [[UIView alloc] init];
  [selectHighlightView setBackgroundColor:[UIColor blackColor]];
  [cell setSelectedBackgroundView: selectHighlightView];
  
  return cell;
}

- (void) dismiss {
  [_hud hide:YES];
  [[self tableView] reloadData];
}

- (void) setProgress:(float) progress {
  //
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if (indexPath.section == 0) {
    // call metro transit
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://612-373-3333"]];
  } else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      NSString *subjectLine = @"Support request from Bus Brain";
      [self composeEmail:@"beetlefight@gmail.com" emailBody:@"" subjectLine:subjectLine];
    } else {
      [_hud show:YES];
      BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
      [DataCache downloadCacheProgress:self main:[app mainTableViewController]];
    }
  } else if (indexPath.section == 2) {
    
    NSString *subjectLine = @"Check out Bus Brain for iPhone!";
    NSString *emailBody = @"Bus Brain provides easy iPhone access to the Twin Cities Metro Transit bus schedule. <a href='https://itunes.apple.com/us/app/bus-brain/id560807582?ls=1&mt=8'>Download it on the App Store</a>";
    [self composeEmail:@"" emailBody:emailBody subjectLine:subjectLine];
  }
  
}

- (void)composeEmail:(NSString *)emailAddr emailBody:(NSString *)emailBody subjectLine:(NSString *)subjectLine {
  
  if ([MFMailComposeViewController canSendMail]) {
    NSArray *recipients = [[NSArray alloc] initWithObjects:emailAddr, nil];
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setToRecipients:recipients];    
    [mailViewController setSubject:subjectLine];
    [mailViewController setMessageBody:emailBody isHTML:YES];
    [[mailViewController navigationBar] setTintColor:[UIColor blackColor]];
    
    [self presentModalViewController:mailViewController animated:YES];
    
  } else {
    // pop an UIAlertView?
    NSLog(@"can't send email");
  }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
  [self dismissModalViewControllerAnimated:YES];
}


@end
