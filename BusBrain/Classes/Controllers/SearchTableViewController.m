//
//  RoutesTableViewController.m
//
//

#import "BusBrainAppDelegate.h"
#import "SearchTableViewController.h"
#import "Route.h"
#import "Stop.h"
#import "StopCell.h"
#import "RouteCell.h"
#import "RouteTableViewController.h"
#import "StopViewController.h"
#import "NSString+BeetleFight.h"
#import "BusBrainAppDelegate.h"

@implementation SearchTableViewController

@synthesize stopSearchArray  = _stopSearchArray;
@synthesize stopsDB          = _stopsDB;
@synthesize myLocation       = _myLocation;
@synthesize searchBar        = _searchBar;
@synthesize greyView         = _greyView;
@synthesize message          = _message;

- (void) viewDidDisappear:(BOOL)animated{
  [[[self main] tableView] reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
  BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
  [app saveAnalytics:@"SearchTableView"];
}

- (void)downloadCache:(UITapGestureRecognizer *)recognizer {
  [[self main] initData:nil];
  [[self main] initLocation];
  
  [[self navigationController] popViewControllerAnimated:YES];
  [[self navigationItem] setHidesBackButton: NO];
}

- (void)cancelSearch:(UITapGestureRecognizer *)recognizer {
  //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
  
  [[self searchBar] resignFirstResponder];
  [[self navigationController] popViewControllerAnimated:YES];
  [[self navigationItem] setHidesBackButton: NO];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *) searchBar {
  [searchBar resignFirstResponder];
  [[self navigationController] popViewControllerAnimated:YES];
  [[self navigationItem] setHidesBackButton: NO];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *) searchBar {
  [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
  
  searchBar.showsScopeBar = YES;
  [searchBar sizeToFit];
  
  searchBar.showsCancelButton = YES;
  return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
  
  searchBar.showsScopeBar = NO;
  [searchBar sizeToFit];
  
  searchBar.showsCancelButton = NO;
  return YES;
}

- (void) buildSearchArrayFrom: (NSString *) searchText {
  if ([searchText length] == 0) {
    [self setStopSearchArray: nil];
    [self setRouteSearchArray:nil];
    
    [[self greyView] setHidden:NO];
    
    [[self tableView] reloadData];
    
  } else {
    
    [self showHUD];
    
    if(_queueSearch == nil){
      _queueSearch = dispatch_queue_create("busbrain_search", 0);
    }
    
    _pendingSearches++;
    
    dispatch_async( _queueSearch, ^{
      if(_pendingSearches == 1){
        [self showHUD];
        
        NSArray *resultRouteArray;
        resultRouteArray = [Route filterRouteArrayByNumber:[self routesDB] filter:searchText];
        [self setRouteSearchArray: resultRouteArray];
      
        
        NSArray *resultStoreArray;
        if ([[self stopSearchArray] count] > 0) {
          resultStoreArray = [Stop filterStopArrayByName:[self stopSearchArray] filter:searchText location:[self myLocation]];
        } else {
          resultStoreArray = [Stop filterStopArrayByName:[self stopsDB] filter:searchText location:[self myLocation]];
        }
        [self setStopSearchArray: resultStoreArray];
        

        dispatch_async( dispatch_get_main_queue(), ^{
          [[self tableView] reloadData];
          [[self greyView] setHidden:YES];
          [[self HUD] hide:YES];
          
        });
      }
      
      _pendingSearches--;

    });
    
  }
	
	
}

// When the search text changes, update the array
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self buildSearchArrayFrom:searchText];
}

- (void) performSearch:(NSString*) searchText {
  [self buildSearchArrayFrom:searchText];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  _pendingSearches = 0;
  
  UIImage *backButton = [[UIImage imageNamed:@"btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
  [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
  
	
  //Setup View
  [self setView:[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
  [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]]];
  
  // Setup Search Bar/Button
  [self buildSearchArrayFrom:@""];
	UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetMaxX(self.view.frame),36.0f)];
	[search setDelegate: self];
	[search setPlaceholder: @""];
	[search setAutocorrectionType: UITextAutocorrectionTypeNo];
	[search setAutocapitalizationType: UITextAutocapitalizationTypeNone];
  [search setTintColor: [UIColor colorWithWhite:0.3 alpha:1.0]];
  
  for (UIView *view in [search subviews]) {
    if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
      [view removeFromSuperview];
    }
    
    if ([view isKindOfClass:[UIButton class]]) {
      [(UIButton *)view setEnabled:YES];
    }
  }
  
  UITextField *searchField = [[search subviews] lastObject];
	[searchField setReturnKeyType:UIReturnKeyDone];
  
	[self setSearchBar:search];
  
  [[self navigationItem] setHidesBackButton: YES];
  [[self navigationItem] setTitleView: [self searchBar]];
  
  //Setup Table View
  [self setTableView:[[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
  [[self tableView] setDelegate:self];
  [[self tableView] setDataSource:self];
  [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]]];
  
  [[self view] addSubview:[self tableView]];
  
  
  
  [self setGreyView:[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
  [self greyView].backgroundColor = [UIColor colorWithRed:(200/255.0) green:(200/255.0) blue:(200/255.0) alpha:0.05f];
  
  float messageMargin = 30;
  [self setMessage: [[UILabel alloc] initWithFrame: CGRectMake(messageMargin, 30, CGRectGetMaxX(self.view.frame) - (2*messageMargin), 30)]];
  [[self message] setAutoresizesSubviews:NO];
  [[self message] setBackgroundColor:[UIColor clearColor]];
  [[self message] setTextColor:[UIColor grayColor]];
  [[self message] setFont:[UIFont boldSystemFontOfSize:13.0]];
  
  if([[self stopsDB] count] > 0){
    [[self message] setText:@"Search by route number or street name"];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(cancelSearch:)];
    [[self greyView] addGestureRecognizer:singleFingerTap];
    [search becomeFirstResponder];
  } else {
    [[self message] setText:@"Search DB is corrupt, tap to download"];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(downloadCache:)];
    [[self greyView] addGestureRecognizer:singleFingerTap];
    [[self searchBar] resignFirstResponder];
  }
  
  [[self greyView] addSubview:[self message]];
  [[self view] addSubview:[self greyView]];

}

- (void)viewDidAppear {

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if(section == 1) {
    return [[self stopSearchArray] count];
  } else {
    return [[self routeSearchArray] count];
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  //NSString *searchText = [[self searchBar] text];
  
  if(section == 1){
    if([[self stopSearchArray] count] > 0){
      return @"Stops";
    } else {
      return nil;
    }
  } else {
    if([[self routeSearchArray] count] > 0){
      return @"Routes";
    } else {
      return nil;
    }
  }
  
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if(indexPath.section == 1) {
     Stop *stop = (Stop *)[[self stopSearchArray] objectAtIndex:[indexPath row]];
     static NSString *CellIdentifier = @"SearchStoreResultCell";
     StopCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[StopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     
     [cell setStop: stop];
     
     [cell setAccessoryView: [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]]];
     [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
     
     return cell;
  } else if(indexPath.section == 0) {
    Route *route = (Route *)[[self routeSearchArray] objectAtIndex:[indexPath row]];
    static NSString *CellIdentifier = @"SearchRouteResultCell";
    RouteCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setRoute: route];
    
    [cell setAccessoryView: [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
  }
  
  return nil;
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if(indexPath.section == 1) {
    Stop *stop = (Stop *)[[self stopSearchArray] objectAtIndex:[indexPath row]];
    RouteTableViewController *target = [[RouteTableViewController alloc] init];
    [target loadRoutesForStop:stop];
    [[self navigationController] pushViewController:target animated:YES];
    
    NSString *searchText = [[self searchBar] text];
    BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app saveAnalytics:[NSString stringWithFormat:@"Search/Stop/%@", searchText]];
  }
  if(indexPath.section == 0) {
    Route *route = (Route *)[[self routeSearchArray] objectAtIndex:[indexPath row]];
    StopViewController *target = [[StopViewController alloc] init];
    [target loadStopsForRoute:route];
    [[self navigationController] pushViewController:target animated:YES];
    
    NSString *searchText = [[self searchBar] text];
    BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app saveAnalytics:[NSString stringWithFormat:@"Search/Route/%@", searchText]];
    
  }
  
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}



@end