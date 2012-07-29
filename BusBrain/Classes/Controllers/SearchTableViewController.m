//
//  RoutesTableViewController.m
//
//

#import "BusBrainAppDelegate.h"
#import "SearchTableViewController.h"
#import "Route.h"
#import "Stop.h"
#import "StopSearchCell.h"
#import "StopTimesTableViewController.h"
#import "NSString+BeetleFight.h"


@implementation SearchTableViewController

@synthesize searchArray = _searchArray;
@synthesize stopsDB     = _stopsDB;
@synthesize myLocation  = _myLocation;

- (void) searchBarCancelButtonClicked:(UISearchBar *) searchBar {
   [searchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *) searchBar {
  [searchBar resignFirstResponder];
}

- (void) buildSearchArrayFrom: (NSString *) searchText {
  if ([searchText length] == 0) {
    [self setSearchArray: [NSArray arrayWithArray:[self stopsDB]]];
  } else {
    [self setSearchArray: [Stop filterStopArray:[self stopsDB] filter:searchText location:[self myLocation]]];
  }
	
	[[self tableView] reloadData];
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
  UIImage *backButton = [[UIImage imageNamed:@"btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
  [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
  
  [self setTableView:[[UITableView alloc] initWithFrame:CGRectMake(22, 207, 270, 233)]];

  [super viewDidLoad];
	
	UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 44.0f)];
	[search setDelegate: self];
	[search setPlaceholder: @""];
	[search setAutocorrectionType: UITextAutocorrectionTypeNo];
	[search setAutocapitalizationType: UITextAutocapitalizationTypeNone];
  for (UIView *view in [search subviews]) {
    if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
      [view removeFromSuperview];
      break;
    }
  }
  UITextField *searchField = [[search subviews] lastObject];
	[searchField setReturnKeyType:UIReturnKeyDone];
  
	[[self navigationItem] setTitleView: search];
	[search release];
  
  [self buildSearchArrayFrom:@""];
  
 
  [[self tableView] setDelegate:self];
  [[self tableView] setDataSource:self];
  [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]]];
  [self setView:[self tableView]];

}

- (void)viewDidAppear {

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self searchArray] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Search Results";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
     Stop *stop = (Stop *)[[self searchArray] objectAtIndex:[indexPath row]];
     static NSString *CellIdentifier = @"SearchResultCell";
     StopSearchCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[[StopSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
     }
     
     [cell setStop: stop];
     
     [cell setAccessoryView: [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]]];
     [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
     
     return cell;
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Stop *stop = (Stop *)[[self searchArray] objectAtIndex:[indexPath row]];
    StopTimesTableViewController *target = [[StopTimesTableViewController alloc] init];
    [target setSelectedStop:stop];
    [target setSelectedRoute:[stop route]];

    [[self navigationController] pushViewController:target animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}


- (void)dealloc {
  [_stopsDB dealloc];
  [_searchArray dealloc];
  [_myLocation dealloc];
  
  [super dealloc];

}

@end