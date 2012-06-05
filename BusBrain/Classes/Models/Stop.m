//
//  Stop.m
//  BusBrain
//
//  Created by Andrew Atkinson on 12/3/11.
//  Copyright 2011 Beetle Fight. All rights reserved.
//

#import "BusBrainAppDelegate.h"
#import "Route.h"
#import "Stop.h"
#import "TransitAPIClient.h"
#import "Headsign.h"

@implementation Stop

@synthesize number               = _number;
@synthesize name                 = _name;
@synthesize street               = _street;
@synthesize lat                  = _lat;
@synthesize lon                  = _lon;
@synthesize location             = _location;
@synthesize nextStopTime         = _nextStopTime; 
@synthesize city                 = _city;
@synthesize desc                 = _desc;
@synthesize refLocation          = _refLocation;
@synthesize distanceFromLocation = _distanceFromLocation;
@synthesize iconPath             = _iconPath;
@synthesize headsignKey          = headsignKey;
@synthesize route                = _route;

- (NSComparisonResult)compareLocation:(Stop *)otherObject {
  return [[self distanceFromLocation] compare:[otherObject distanceFromLocation]];
}

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  [self setName: [attributes valueForKeyPath:@"stop_name"]];
  [self setNumber: [attributes valueForKeyPath:@"stop_id"]];
  [self setDesc: [attributes valueForKeyPath:@"stop_desc"]];
  [self setLat: [attributes valueForKeyPath:@"stop_lat"]];
  [self setLon: [attributes valueForKeyPath:@"stop_lon"]];
  [self setCity: [attributes valueForKeyPath:@"stop_city"]];
  [self setLocation:[[CLLocation alloc] initWithLatitude:[[self lat] floatValue] 
                                               longitude:[[self lon] floatValue]]];

  NSString *family = [attributes valueForKeyPath:@"route_family"];
  if (family != (id)[NSNull null] ) {
    [self setIconPath: [NSString stringWithFormat: @"icon_%@.png", family]];
  }

  [self setHeadsignKey: [attributes valueForKeyPath:@"headsign_key"]];

  [self setRoute: [[Route alloc] initWithAttributes:(NSDictionary*)[attributes objectForKey:@"route"]]];
  
  return self;
}

- (void) setRefLocation:(CLLocation *)thisLocation{
  refLocation = thisLocation;
  double dist = [[self location] distanceFromLocation:thisLocation] / 1609.344;
  [self setDistanceFromLocation:[NSNumber numberWithDouble:dist]];
}

- (void) loadNextStopTime {
  [StopTime stopTimesSimple:[[self route ] number]  stop:[self number] near:nil  block:^(NSArray *stops) {

      if ([stops count] > 0) {
        [self setNextStopTime:(StopTime *)[stops objectAtIndex:0]];
      } else {
        [self setNextStopTime:nil];
      }
                
     }
   ];
}

+ (void) loadStopsDB:(void (^)(NSArray *records))block {
  NSString *filepath = [[NSBundle mainBundle] pathForResource:@"Stops" ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filepath];
  
  NSMutableArray *mutableRecords = [NSMutableArray array];
  for (NSDictionary *attributes in [[NSArray alloc] initWithArray :[dict objectForKey:@"stops"]]) {
    Stop *stop = [[[Stop alloc] initWithAttributes:attributes] autorelease];
    [mutableRecords addObject:stop];
  }
  
  if (block) {
    block ([NSArray arrayWithArray:mutableRecords]);
  }
}

+ (NSArray*) filterStopArray:(NSArray*) stopArray filter:(NSString*) filterString location:(CLLocation *)location {
  NSString *match = [NSString stringWithFormat:@"*%@*", filterString];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like[c] %@", match];
  
  NSMutableArray *resultArray = [NSMutableArray arrayWithArray:stopArray];
  [resultArray filterUsingPredicate:predicate];
  
  NSEnumerator *e = [resultArray objectEnumerator];
  Stop *stop;
  while (stop = [e nextObject]) {
    [stop setRefLocation:location];
  }
  
  NSArray *sortedArray;
  sortedArray = [resultArray sortedArrayUsingSelector:@selector(compareLocation:)];
  
  return sortedArray;
}

+ (void) nearbyStops:(CLLocation *)location block:(void (^)(NSArray *records))block {
  NSString *filepath = [[NSBundle mainBundle] pathForResource:@"NearbyStops" ofType:@"plist"];
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filepath];

  NSMutableArray *mutableRecords = [NSMutableArray array];
  for (NSDictionary *attributes in [[NSArray alloc] initWithArray :[dict objectForKey:@"stops"]]) {
    Stop *stop = [[[Stop alloc] initWithAttributes:attributes] autorelease];
    [stop setRefLocation:location];
    [mutableRecords addObject:stop];
  }

  NSArray *sortedArray;
  sortedArray = [mutableRecords sortedArrayUsingSelector:@selector(compareLocation:)];
  
  
  
  if (block) {
    //block ([NSArray arrayWithArray:sortedArray]);
    block ([NSArray arrayWithObjects:[sortedArray objectAtIndex:0],
            [sortedArray objectAtIndex:1],
            [sortedArray objectAtIndex:2], nil]);
  }
}

+ (void)getStops:(NSString *)route_id stop_id:(NSString *)stop_id block:(void (^)(NSArray *records))block {
  NSString *urlString = [NSString stringWithFormat:@"train/v1/routes/%@/stops/all", route_id];
  
#ifdef DEBUG_BB
    NSLog(@"DEBUG: %@", urlString);
#endif
  
  [[TransitAPIClient sharedClient] getPath:urlString parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
     NSMutableArray *mutableRecords = [NSMutableArray array];
     for (NSDictionary *attributes in [JSON valueForKeyPath:@"stops"]) {
       Stop *stop = [[[Stop alloc] initWithAttributes:attributes] autorelease];
       
       if( stop_id == (id)[NSNull null] || [stop_id isEqualToString:[stop number]]){
         [mutableRecords addObject:stop];
       }
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

- (void) loadRoute:(NSString*)route_id {
  [Route getRoute:route_id block:^(NSArray *routes) {
    if ([routes count] > 0 ) {
      [self setRoute:(Route *)[routes objectAtIndex:0]];
      [self loadNextStopTime];
    } else {
      [self setRoute:nil];
    }
  }];
}

+ (NSArray *)stopsFromArray:(NSArray *)array {
  NSMutableArray *mutableRecords = [NSMutableArray array];
  for (NSDictionary *attributes in array) {
    Stop *stop = [[[Stop alloc] initWithAttributes:attributes] autorelease];
    [mutableRecords addObject:stop];
  }

  return mutableRecords;
}

+ (void)stopsWithHeadsigns:(NSString *)urlString near:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^)(NSDictionary *data))block {
  NSDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];

  [[TransitAPIClient sharedClient] getPath:urlString parameters:mutableParameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {

     NSMutableDictionary *data = [NSMutableDictionary dictionary];

     NSMutableArray *headsigns = [NSMutableArray array];
     for (NSDictionary *attributes in [JSON valueForKeyPath:@"headsigns"]) {
       Headsign *headsign = [[[Headsign alloc] initWithAttributes:attributes] autorelease];
       [headsigns addObject:headsign];
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

     NSMutableArray *stopsIndex0 = [NSMutableArray array];
     NSMutableArray *stopsIndex1 = [NSMutableArray array];

     Headsign *h0 = (Headsign *)[headsigns objectAtIndex:0];
     Headsign *h1 = (Headsign *)[headsigns objectAtIndex:1];

     for(Stop *stop in sortedStops) {
       if ([[stop headsignKey] isEqualToString: [h0 headsignKey]]) {
         [stopsIndex0 addObject:stop];
       } else if ([[stop headsignKey] isEqualToString:[h1 headsignKey]]) {
         [stopsIndex1 addObject:stop];
       }
     }

     [data setObject:headsigns forKey:@"headsigns"];
     [data setObject:stopsIndex0 forKey:@"stopsIndex0"];
     [data setObject:stopsIndex1 forKey:@"stopsIndex1"];

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
