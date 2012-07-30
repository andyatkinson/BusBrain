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
@synthesize searchBar   = _searchBar;

- (void) searchBarCancelButtonClicked:(UISearchBar *) searchBar {
  [self toggleSearch:nil];
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

- (void) toggleSearch:(id)sender {
  // get the height of the search bar
  float delta = self.searchBar.frame.size.height;
  // check if toolbar was visible or hidden before the animation
  BOOL isHidden = [self.searchBar isHidden];
  
  // if search bar was visible set delta to negative value so that animation goes up not down
  if (isHidden){
    // if search bar was hidden then make it visible before animation begins
    self.searchBar.hidden = NO;
  }
  
  [UIView animateWithDuration:0.3 delay: 0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{

    CGRect searchFrame = self.searchBar.frame;
    CGRect tableFrame  = self.tableView.frame;
    if (isHidden){
      searchFrame = CGRectOffset(searchFrame, 0.0, delta);
      tableFrame = CGRectMake(0, CGRectGetMinY(tableFrame) + delta, CGRectGetMaxX(tableFrame), CGRectGetMaxY(tableFrame) );
    } else {
      searchFrame = CGRectOffset(searchFrame, 0.0, -delta);
      tableFrame  = CGRectMake(0, 0, CGRectGetMaxX(tableFrame), CGRectGetMaxY(tableFrame) );
    }
    
    self.searchBar.frame = searchFrame;
    self.tableView.frame = tableFrame;
    
  }
                   completion:^(BOOL finished){
                     // on completion if the bar was originally visible then hide it
                     if (!isHidden){
                       self.searchBar.hidden = YES;
                       [self.searchBar resignFirstResponder];
                     }
                   }];
}


- (void)viewDidLoad {
  UIImage *backButton = [[UIImage imageNamed:@"btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
  [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
  
  [super viewDidLoad];
	
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
  
  //[search setBarStyle:UIBarStyleBlack];
  //[search setTranslucent:YES];
  
  for (UIView *view in [search subviews]) {
    if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
      [view removeFromSuperview];
      break;
    }
  }
  
  UITextField *searchField = [[search subviews] lastObject];
	[searchField setReturnKeyType:UIReturnKeyDone];
  
  UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                   target:self
                                   action:@selector(toggleSearch:)];
  [searchButton setTintColor:[UIColor blackColor]];
  [[self navigationItem] setRightBarButtonItem:searchButton];
	//[[self navigationItem] setTitleView: search];
	[self setSearchBar:search];
  
  //Hide the search
  float delta = self.searchBar.frame.size.height;
  CGRect searchFrame = self.searchBar.frame;
  searchFrame = CGRectMake(0, -delta, CGRectGetMaxX(searchFrame), delta);
  self.searchBar.frame = searchFrame;
  self.searchBar.hidden = YES;
  
  [[self view] addSubview:[self searchBar]];
  
  
  
  //Setup Table View
  [self setTableView:[[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
  [[self tableView] setDelegate:self];
  [[self tableView] setDataSource:self];
  [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]]];
  
  [[self view] addSubview:[self tableView]];
  
  //Toggle the search into view
  [self toggleSearch:searchButton];

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