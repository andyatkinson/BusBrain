//
//  RouteCell.h
//  BusBrain
//
//  Created by John Doll on 1/13/13.
//
//

#import "BusTableCell.h"
#import "Route.h"

@interface RouteCell : BusTableCell {
  UILabel *_routeName;
  UILabel *_routeNumber;
}

@property (nonatomic, strong) UILabel *routeName;
@property (nonatomic, strong) UILabel *routeNumber;

- (void) setRoute:(Route*) route;

@end
