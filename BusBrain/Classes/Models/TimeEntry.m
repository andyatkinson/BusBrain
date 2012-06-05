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

@synthesize headsignKeys = _headsignKeys;
@synthesize headsigns    = _headsigns;
@synthesize template     = _template;
@synthesize stopTimes    = _stopTimes;

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  [self setHeadsignKeys: [attributes valueForKeyPath:@"headsign_keys"]];
  [self setHeadsigns: [attributes valueForKeyPath:@"headsigns"]];
  [self setTemplate: [attributes valueForKeyPath:@"template"]];
  [self setStopTimes: [StopTime stopTimesFromArray:[attributes valueForKeyPath:@"stop_times"]]];

  return self;
}


@end
