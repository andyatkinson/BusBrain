//
//  Headsign.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "Headsign.h"

@implementation Headsign

@synthesize headsign_key, headsign_public_name;

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  self.headsign_key = [attributes valueForKeyPath:@"headsign_key"];
  self.headsign_public_name = [attributes valueForKeyPath:@"headsign_public_name"];

  return self;
}

@end
