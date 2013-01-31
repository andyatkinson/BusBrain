//
//  Trip.m
//  BusBrain
//
//  Created by John Doll on 1/6/13.
//
//

#import "Trip.h"

@implementation Trip

@synthesize trip_ids      = _trip_ids;
@synthesize trip_headsign = _trip_headsign;
@synthesize date          = _date;
@synthesize hour          = _hour;
@synthesize minute        = _minute;

- (id)init {
  self = [super init];
  if (!self) {
    return nil;
  }
  
  return self;
}

- (NSString*) getDirection {
  
  NSRange northRange;
  NSRange southRange;
  NSRange eastRange;
  NSRange westRange;

  northRange = [self.trip_headsign rangeOfString:@"north" options:NSCaseInsensitiveSearch];  
  if(northRange.location != NSNotFound) {
    return @"N";
  }
  
  southRange = [self.trip_headsign rangeOfString:@"south" options:NSCaseInsensitiveSearch];
  if(southRange.location != NSNotFound) {
    return @"S";
  }
  
  eastRange = [self.trip_headsign rangeOfString:@"east" options:NSCaseInsensitiveSearch];
  if(eastRange.location != NSNotFound) {
    return @"E";
  }
  
  westRange = [self.trip_headsign rangeOfString:@"west" options:NSCaseInsensitiveSearch];
  if(westRange.location != NSNotFound) {
    return @"W";
  }
  
  return @"N";
}

@end
