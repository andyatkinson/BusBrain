//
//  Headsign.m
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "Headsign.h"

@implementation Headsign

@synthesize headsign_key        = _headsign_key;
@synthesize headsign_name = _headsign_name;

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  [self setHeadsign_key: [attributes valueForKeyPath:@"headsign_key"]];
  [self setHeadsignPublicName: [attributes valueForKeyPath:@"headsign_name"]];

  return self;
}

- (void)dealloc {
  [_headsign_key dealloc];
  [_headsign_name dealloc];
  
  [super dealloc];
}
@end
