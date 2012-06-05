//
//  BusTable.h
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"

@interface BusTable : UITableViewController <UITableViewDelegate, MBProgressHUDDelegate, EGORefreshTableHeaderDelegate> {
  UITableView       *_tableView;
  MBProgressHUD     *_HUD;
  EGORefreshTableHeaderView *_refreshHeaderView;
  
}

@property (nonatomic, retain) UITableView               *tableView;
@property (nonatomic, retain) MBProgressHUD             *HUD;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;

- (void) showHUD;
- (void) initPullRefresh;
- (void) loadData;

@end
