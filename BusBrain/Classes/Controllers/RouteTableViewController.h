//
//  RouteTableViewController.h
//  BusBrain
//
//  Created by John Doll on 1/5/13.
//
//

#import "BusTable.h"
#import "Stop.h"

@interface RouteTableViewController : BusTable <UITableViewDelegate, UITableViewDataSource> {
  NSArray   *_routes;
  Stop      *_stop;
}

@property (nonatomic, strong) NSArray *routes;
@property (nonatomic, strong) Stop    *stop;

- (void) loadRoutesForStop:(Stop*) stop;

@end
