//
//  StopViewController.h
//  BusBrain
//
//  Created by John Doll on 1/6/13.
//
//

#import "BusTable.h"
#import "Route.h"

@interface StopViewController : BusTable <UITableViewDelegate, UITableViewDataSource> {
  NSArray   *_stops;
  Route     *_route;
}

@property (nonatomic, strong) NSArray *stops;
@property (nonatomic, strong) Route   *route;

- (void) loadStopsForRoute:(Route*) route;

@end
