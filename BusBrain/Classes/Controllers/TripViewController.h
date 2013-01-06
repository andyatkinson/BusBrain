//
//  TripViewController.h
//  BusBrain
//
//  Created by John Doll on 1/6/13.
//
//

#import "BusTable.h"
#import "Stop.h"

@interface TripViewController : BusTable <UITableViewDelegate, UITableViewDataSource> {
  NSArray   *_trips;
  Stop      *_stop;
}

@property (nonatomic, strong) NSArray *trips;
@property (nonatomic, strong) Stop    *stop;

- (void) loadTripsForStop:(Stop*) stop;

@end
