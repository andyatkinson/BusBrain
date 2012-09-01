//
//  Route.m
//  BusBrain
//
//  Created by Andrew Atkinson on 12/2/11.
//  Copyright 2011 Beetle Fight. All rights reserved.
//

#import "BusBrainAppDelegate.h"
#import "Route.h"
#import "Stop.h"
#import "TransitAPIClient.h"

@implementation Route

@synthesize route_id    = _route_id;
@synthesize long_name  = _long_name;
@synthesize short_name = _short_name;
@synthesize route_desc      = _route_desc;
@synthesize route_type      = _route_type;
@synthesize route_url       = _route_url;
@synthesize icon_path  = _icon_path;

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  self.route_id = [attributes valueForKeyPath:@"route_id"];
  self.long_name = [attributes valueForKeyPath:@"long_name"];
  self.short_name = [attributes valueForKeyPath:@"short_name"];
  self.route_desc = [attributes valueForKeyPath:@"route_desc"];
  self.route_type = [attributes valueForKeyPath:@"route_type"];
  self.route_url = [attributes valueForKeyPath:@"route_url"];
  
  NSString *family = [attributes valueForKeyPath:@"route_family"];
  if ([family length] > 0) {
    self.icon_path = [NSString stringWithFormat: @"icon_%@.png", family];
  }
  
  return self;
}

+ (void) routesFromPlist:(void (^)(NSArray *records))block {
  NSString *filepath = [[NSBundle mainBundle] pathForResource:@"Routes" ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filepath];

  NSMutableArray *mutableRecords = [NSMutableArray array];
  for (NSDictionary *attributes in [[NSArray alloc] initWithArray :[dict objectForKey:@"routes"]]) {
    if([mutableRecords count] < 5) {
      Route *route = [[[Route alloc] initWithAttributes:attributes] autorelease];
      [mutableRecords addObject:route];
    }
  }

  if (block) {
    block ([NSArray arrayWithArray:mutableRecords]);
  }
}

+ (void) routesFromPlist:(CLLocation *)location block:(void (^)(NSArray *records))block {
  [Route routesFromPlist:^(NSArray *routeData) {
     if (block) {
       block ([NSArray arrayWithArray:routeData]);
     }
   }];
}

@end