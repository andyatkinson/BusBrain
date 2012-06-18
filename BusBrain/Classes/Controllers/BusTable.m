//
//  BusTable.m
//
//
#import "BusTable.h"
#import "BusLooknFeel.h"

@implementation BusTable

@synthesize tableView         = _tableView; 
@synthesize HUD               = _HUD;
@synthesize refreshHeaderView = _refreshHeaderView;

-(void) hudWasHidden {
  
}

-(void) showHUD {
  /* Progress HUD overlay START */
  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  _HUD = [[MBProgressHUD alloc] initWithWindow:window];
  [window addSubview:_HUD];
  [_HUD setDelegate: self];
  [_HUD setLabelText:@"Loading"];
  [_HUD show:YES];
  /* Progress HUD overlay END */
}

- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
  if ([self tableView:tv titleForHeaderInSection:section] != nil) {
    return 27; // want to eliminate a 1px bottom gray line, and a 1px bottom white line under
  }
  else {
    // If no section header title, no section header needed
    return 0;
  }
}

- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section {

  UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,[[self tableView] frame].size.width,30)] autorelease];

  UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,[headerView frame].size.width, [headerView frame].size.height)];
  [headerLabel setText: [self tableView:tv titleForHeaderInSection:section]];
  [headerLabel setTextAlignment: UITextAlignmentLeft];
  
  
  [headerLabel setFont: [BusLooknFeel getHeaderFont]];
  [headerLabel setTextColor:[BusLooknFeel getHeaderTextColor]];
  [headerLabel setShadowColor:[BusLooknFeel getHeaderShadowtColor]];
  [headerLabel setShadowOffset: CGSizeMake(0,1)];

  [headerLabel setBackgroundColor: [UIColor clearColor]];
  [headerView addSubview:headerLabel];

  [headerView setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"header_bar_default.png"]]];

  return headerView;
}

- (void)tableView:(UITableView *)tv accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

  [self tableView:tv didSelectRowAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void) initPullRefresh {
  if ([self refreshHeaderView] == nil) {
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - [[self tableView] bounds].size.height, [[self view] frame].size.width, [[self tableView] bounds].size.height)];
    [view setDelegate:self];
    [[self tableView] addSubview:view];
    [self setRefreshHeaderView:view];
    [view release];
  }
  
  //  update the last update date
  [_refreshHeaderView refreshLastUpdatedDate];
}

- (void) loadData {
  
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
  [self loadData];
  [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
  
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
  
  //return _reloading; // should return if data source model is reloading
  return NO;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
  
  return [NSDate date];       // should return date data source was last changed
  
}

- (void) dealloc {
  [_tableView dealloc];
  [_HUD dealloc];
  [_refreshHeaderView dealloc];
  
  [super dealloc];
 
}

@end