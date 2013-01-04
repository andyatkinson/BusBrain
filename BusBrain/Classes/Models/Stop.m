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

@synthesize stop_id, stop_name, stop_street, stop_lat, stop_lon, location, headsign, icon_path, route;
@synthesize nextStopTime, refLocation, distanceFromLocation;
@synthesize nextTripStopID,nextTripStopTimes, nextTripBusLocations;

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }
  
  self.stop_name = [attributes valueForKeyPath:@"stop_name"];
  self.stop_id = [attributes valueForKeyPath:@"stop_id"];
  self.stop_lat = [attributes valueForKeyPath:@"stop_lat"];
  self.stop_lon = [attributes valueForKeyPath:@"stop_lon"];
  self.location = [[[CLLocation alloc] initWithLatitude:self.stop_lat.floatValue longitude:self.stop_lon.floatValue] autorelease];
  
  NSString *family = [attributes valueForKeyPath:@"route_family"];
  if ([family length] > 0) {
    self.icon_path = [NSString stringWithFormat: @"icon_%@.png", family];
  }
  
  self.headsign = [[Headsign alloc] init];
  self.headsign.headsign_name = [attributes valueForKeyPath:@"headsign_name"];
  
  self.route = [[Route alloc] init];
  self.route.route_id = [attributes valueForKeyPath:@"route_id"];
  
  self.route.short_name = [attributes valueForKeyPath:@"route_short_name"];
  
  return self;
}

- (NSComparisonResult)compareLocation:(Stop *)otherObject {
  return [[self distanceFromLocation] compare:[otherObject distanceFromLocation]];
}

- (void) setRefLocation:(CLLocation *)thisLocation{
  refLocation = thisLocation;
  double dist = [[self location] distanceFromLocation:thisLocation] / 1609.344;
  [self setDistanceFromLocation:[NSNumber numberWithDouble:dist]];
}

- (void) loadNextStopTime {
  NSLog(@"Load next stop time for Route: %@, Stop, %@", [[self route ] route_id] , [self stop_id] );
  [StopTime stopTimesSimple:[[self route ] route_id]  stop:[self stop_id] near:nil  block:^(NSArray *stops) {

      if ([stops count] > 0) {
        [self setNextStopTime:(StopTime *)[stops objectAtIndex:0]];
      } else {
        [self setNextStopTime:nil];
      }
                
     }
   ];
}

- (void) loadNextTripTimes:(void (^)(BOOL))block {
  NSString *urlString = [NSString stringWithFormat:@"http://svc.metrotransit.org/NexTrip/%@",[self stop_id]];
  NSLog(@"URL == %@", urlString);
  
  NSDictionary *parameters = [[NSMutableDictionary alloc] init];
  [parameters setValue:@"Json" forKey:@"format"];
  
  [[TransitAPIClient sharedClient] getPath:urlString parameters:parameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
    

    NSMutableArray *nextTripTimes     = [[NSMutableArray alloc] init];
    NSMutableArray *nextTripLocations = [[NSMutableArray alloc] init];
    
    NSEnumerator *e = [JSON objectEnumerator];
    NSDictionary *attributes;
  
    while (attributes = (NSDictionary *)[e nextObject]) {
      //NSLog(@"XXX: %i, %@", [(NSNumber*)[attributes valueForKeyPath:@"Actual"] integerValue], [[self route ] short_name] );
      
      if([(NSNumber*)[attributes valueForKeyPath:@"Actual"] integerValue] == 1 && [[attributes valueForKeyPath:@"Route"] isEqualToString:[[self route ] short_name]]) {
        NSLog(@"DEBUG: (%@) %@ -- %@, %@",
              (NSNumber*)[attributes valueForKeyPath:@"Actual"],
              [attributes valueForKeyPath:@"DepartureText"],
              (NSNumber*)[attributes valueForKeyPath:@"VehicleLatitude"],
              (NSNumber*)[attributes valueForKeyPath:@"VehicleLongitude"]);
        
        NSLog(@"XXX: %@", [attributes valueForKeyPath:@"DepartureText"]);
        
        [nextTripTimes addObject:[attributes valueForKeyPath:@"DepartureText"]];
        [nextTripLocations addObject:[[CLLocation alloc]
                                      initWithLatitude:[(NSNumber*)[attributes valueForKeyPath:@"VehicleLatitude"] floatValue]
                                      longitude:[(NSNumber*)[attributes valueForKeyPath:@"VehicleLongitude"] floatValue]]];
      }
      
    }
    
    [self setNextTripStopTimes: [[NSArray alloc] initWithArray:nextTripTimes] ];
    [self setNextTripBusLocations: [[NSArray alloc] initWithArray:nextTripLocations] ];
    
    //Callback
    if (block) {
      block (YES);
    }
    
  } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
    if (block) {
      NSLog(@"ERROR: %@", error);
      block (NO);
    }
  }];
}

+ (void) loadStopsDB:(void (^)(NSArray *records))block {
  NSString *documentsDirectory = [NSHomeDirectory() 
                                  stringByAppendingPathComponent:@"Documents"];
  NSString *filepath = [documentsDirectory 
                            stringByAppendingPathComponent:@"CacheStops.json"];
  
  if(! [[NSFileManager defaultManager] fileExistsAtPath:filepath]){
    filepath = [[NSBundle mainBundle] pathForResource:@"search_objects_api_json_dump" ofType:@"json"];
  }
  
  NSLog(@"Loading: %@", filepath);
  
  NSData* jsonData = [NSData dataWithContentsOfFile:filepath];
  NSMutableArray *mutableRecords = [NSMutableArray array];
  
  if(jsonData == nil){
    NSLog(@"No Data?");
  } else {
    NSError* error;
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:kNilOptions
                                                           error:&error];
    NSArray* stopDictArray = [jsonDictionary objectForKey:@"search_objects"];

    for (NSDictionary *attributes in stopDictArray) {
      Stop *stop = [[[Stop alloc] initWithAttributes:attributes] autorelease];
      [mutableRecords addObject:stop];
    }
  }
  
  
  if (block) {
    block ([NSArray arrayWithArray:mutableRecords]);
  }
}

+ (NSArray*) filterStopArrayByName:(NSArray*) stopArray filter:(NSString*) filterString location:(CLLocation *)location {
  NSString *match = [NSString stringWithFormat:@"*%@*", filterString];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stop_name like[c] %@", match];
  
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

+ (NSArray*) filterStopArrayByNumber:(NSArray*) stopArray filter:(NSString*) filterString location:(CLLocation *)location {
  NSString *match = [NSString stringWithFormat:@"%@", filterString];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"route.short_name == %@", match];
  
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

+ (void) loadNearbyStops:(NSString *)urlString near:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^)(NSDictionary *data))block {
  NSDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
  
  NSMutableDictionary *data = [NSMutableDictionary dictionary];
  NSMutableArray *stops = [NSMutableArray array];
  
  /*
  NSLog(@"URL: %@", urlString);
  for(NSString* key in [parameters allKeys]){
    NSLog(@"DEBUG: %@ = %@", key, [parameters objectForKey:key]);
  }
  */
  
  [[TransitAPIClient sharedClient] getPath:urlString parameters:mutableParameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
    
    //Get Nearby Stops off response
    for (NSDictionary *attributes in [JSON valueForKeyPath:@"stops"]) {
      Stop *stop = [[[Stop alloc] initWithAttributes:attributes] autorelease];
      
      [stops addObject:stop];
    }
    [data setObject:stops forKey:@"stops"];
    
    
    //Get Last Viewed Stop off response
    NSMutableDictionary *lastViewed = [[NSMutableDictionary alloc] init];
    NSDictionary *parsedDict = [JSON valueForKeyPath:@"last_viewed"];
    if ([parsedDict valueForKey:@"stop"]) {
      NSDictionary *stopAttributes = [parsedDict valueForKeyPath:@"stop"];
      Stop *stop = [[[Stop alloc] initWithAttributes:stopAttributes] autorelease];
      
      
      if ( [parsedDict valueForKey:@"next_departure"] != (id)[NSNull null] ) {
        NSMutableDictionary *timeAttributes = [[NSMutableDictionary alloc] init];
        [timeAttributes setValue:@"NA" forKey:@"price"];
        [timeAttributes setValue:[parsedDict valueForKey:@"next_departure"] forKey:@"departure_time"];
        StopTime *stop_time = [[[StopTime alloc] initWithAttributes:timeAttributes] autorelease];
        [stop setNextStopTime:stop_time];
      } else {
        [stop setNextStopTime:nil];
      }
      
      [lastViewed setValue:stop forKey:@"stop"];
    }
    [data setObject:lastViewed forKey:@"last_viewed"];
    
    
    //Setup return
    if (block) {
      block([NSDictionary dictionaryWithDictionary:data]);
    }
  } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
    if (block) {
      block([NSArray array]);
    }
  }];
}

+ (void)getStops:(NSString *)route_id stop_id:(NSString *)stop_id block:(void (^)(NSArray *records))block {
  NSString *urlString = [NSString stringWithFormat:@"bus/v1/routes/%@/stops/all", route_id];
  
#ifdef DEBUG_BB
    NSLog(@"DEBUG: %@", urlString);
#endif
  
  [[TransitAPIClient sharedClient] getPath:urlString parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
     NSMutableArray *mutableRecords = [NSMutableArray array];
     for (NSDictionary *attributes in [JSON valueForKeyPath:@"stops"]) {
       Stop *stop = [[[Stop alloc] initWithAttributes:attributes] autorelease];
       
       if( stop_id == (id)[NSNull null] || [stop_id isEqualToString:[stop stop_id]]){
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



@end
