//
//  Headsign.m
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "Headsign.h"

@implementation Headsign

@synthesize headsignKey        = _headsignKey;
@synthesize headsignPublicName = _headsignPublicName;

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  [self setHeadsignKey: [attributes valueForKeyPath:@"headsign_key"]];
  [self setHeadsignPublicName: [attributes valueForKeyPath:@"headsign_public_name"]];

  return self;
}

- (void)dealloc {
  [_headsignKey dealloc];
  [_headsignPublicName dealloc];
  
  [super dealloc];
}
@end
