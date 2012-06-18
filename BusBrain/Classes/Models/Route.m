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

@synthesize number    = _number;
@synthesize longName  = _longName;
@synthesize shortName = _shortName;
@synthesize desc      = _desc;
@synthesize type      = _type;
@synthesize url       = _url;
@synthesize iconPath  = _iconPath;

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  [self setNumber: [attributes valueForKeyPath:@"route_id"]];
  [self setLongName: [attributes valueForKeyPath:@"long_name"]];
  [self setShortName: [attributes valueForKeyPath:@"short_name"]];
  [self setDesc: [attributes valueForKeyPath:@"route_desc"]];
  [self setType: [attributes valueForKeyPath:@"route_type"]];
  [self setUrl: [attributes valueForKeyPath:@"route_url"]];

  NSString *family = [attributes valueForKeyPath:@"route_family"];
  if (family != (id)[NSNull null] ) {
    [self setIconPath: [NSString stringWithFormat: @"icon_%@.png", family]];
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

+ (void) getRoute:(NSString *)route_id block:(void (^)(NSArray *records))block {
  [Route routesFromPlist:^(NSArray *routeData) {
    if (block) {
      NSMutableArray *mutableRecords = [NSMutableArray array];
      NSEnumerator *e = [routeData objectEnumerator];
      Route *route;
      while (route = [e nextObject]) {
        if( route_id == (id)[NSNull null] || [route_id isEqualToString:[route number]]){
          [mutableRecords addObject:route];
        }
      }

      block ([NSArray arrayWithArray:mutableRecords]);
    }
  }];
}

+ (void)routesWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters block:(void (^)(NSArray *records))block {
  NSDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];

  [[TransitAPIClient sharedClient] getPath:urlString parameters:mutableParameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
     NSMutableArray *mutableRecords = [NSMutableArray array];
     for (NSDictionary *attributes in [JSON valueForKeyPath:@"routes"]) {
       Route *route = [[[Route alloc] initWithAttributes:attributes] autorelease];
       [mutableRecords addObject:route];
     }

     if (block) {
       block ([NSArray arrayWithArray:mutableRecords]);
     }
   } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
     if (block) {
       block ([NSArray array]);
     }
   }];
}

+ (void)routesWithNearbyStops:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^)(NSDictionary *data))block {
  NSString *urlString = @"train/v1/routes/nearby_stops";
#ifdef DEBUG_BB
  NSLog(@"DEBUG: %@", urlString);
#endif
  
  NSDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];

  if (location) {
    [mutableParameters setValue:[NSString stringWithFormat:@"%1.7f", location.coordinate.latitude] forKey:@"lat"];
    [mutableParameters setValue:[NSString stringWithFormat:@"%1.7f", location.coordinate.longitude] forKey:@"lon"];
  }

  [[TransitAPIClient sharedClient] getPath:urlString parameters:mutableParameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {

     NSMutableDictionary *data = [NSMutableDictionary dictionary];

     NSMutableArray *routes = [NSMutableArray array];
     for (NSDictionary *attributes in [JSON valueForKeyPath:@"routes"]) {
       Route *route = [[[Route alloc] initWithAttributes:attributes] autorelease];
       [routes addObject:route];
     }

     NSMutableDictionary *lastViewedResult = [[NSMutableDictionary alloc] init];
     NSDictionary *lastViewed = [JSON valueForKeyPath:@"last_viewed"];
     if ([lastViewed valueForKey:@"next_departure"] != NULL) {
       NSString *nextDeparture = [lastViewed valueForKey:@"next_departure"];
       [lastViewedResult setValue:nextDeparture forKey:@"next_departure"];
     }
     if ([lastViewed valueForKey:@"stop"] != NULL) {
       Stop *stop = [[[Stop alloc] initWithAttributes:[lastViewed valueForKey:@"stop"]] autorelease];
       [lastViewedResult setValue:stop forKey:@"stop"];
     }


     NSMutableArray *stops = [NSMutableArray array];
     for (NSDictionary *attributes in [JSON valueForKeyPath:@"stops"]) {
       Stop *stop = [[[Stop alloc] initWithAttributes:attributes] autorelease];
       [stops addObject:stop];
     }

     NSArray *sortedStops = [stops sortedArrayUsingComparator:^ NSComparisonResult (id obj1, id obj2) {
                               CLLocationDistance d1 = [[(Stop *) obj1 location] distanceFromLocation:location];
                               CLLocationDistance d2 = [[(Stop *) obj2 location] distanceFromLocation:location];

                               if (d1 < d2) {
                                 return NSOrderedAscending;
                               } else if (d1 > d2) {
                                 return NSOrderedDescending;
                               } else {
                                 return NSOrderedSame;
                               }
                             }];

     [data setObject:routes forKey:@"routes"];
     [data setObject:lastViewedResult forKey:@"last_viewed"];
     [data setObject:sortedStops forKey:@"stops"];

     if (block) {
       block ([NSDictionary dictionaryWithDictionary:data]);
     }
   } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
     if (block) {
       block ([NSArray array]);
     }
   }];
}


@end

