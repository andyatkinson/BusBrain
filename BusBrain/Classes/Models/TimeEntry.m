//
//  TimeEntry.m
//  BusBrain
//
//  Created by Andrew Atkinson on 2/5/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "TimeEntry.h"
#import "StopTime.h"

@implementation TimeEntry

@synthesize headsign_keys, headsigns, template, stop_times;

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  self.headsign_keys = [attributes valueForKeyPath:@"headsign_keys"];
  self.headsigns = [attributes valueForKeyPath:@"headsigns"];
  self.template = [attributes valueForKeyPath:@"template"];
  self.stop_times = [StopTime stopTimesFromArray:[attributes valueForKeyPath:@"stop_times"]];

  return self;
}

@end
