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

@property (nonatomic, strong) UITableView               *tableView;
@property (nonatomic, strong) MBProgressHUD             *HUD;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;

- (void) showHUD;
- (void) initPullRefresh;
- (void) loadData;

@end
