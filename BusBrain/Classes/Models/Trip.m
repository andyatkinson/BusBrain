//
//  Trip.m
//  BusBrain
//
//  Created by John Doll on 1/6/13.
//
//

#import "Trip.h"

@implementation Trip

@synthesize trip_id       = _trip_id;
@synthesize trip_headsign = _trip_headsign;
@synthesize date          = _date;
@synthesize hour          = _hour;
@synthesize minute        = _minute;

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }
  
  self.trip_id       = [attributes valueForKeyPath:@"trip_id"];
  self.trip_headsign = [attributes valueForKeyPath:@"trip_headsign"];
  
  return self;
}

@end
