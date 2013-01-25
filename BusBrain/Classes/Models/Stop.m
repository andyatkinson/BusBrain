//
//  Stop.m
//  BusBrain
//
//  Created by Andrew Atkinson on 12/3/11.
//  Copyright 2011 Beetle Fight. All rights reserved.
//

#import "BusBrainAppDelegate.h"
#import "Trip.h"
#import "Route.h"
#import "Stop.h"
#import "TransitAPIClient.h"
#import "NSDate+BusBrain.h"

@implementation Stop

@synthesize stop_id, stop_name, stop_street, stop_city, stop_lat, stop_lon, location, icon_path;
@synthesize route, trip;
@synthesize nextStopTime, refLocation, distanceFromLocation;
@synthesize nextTripStopID,nextTripStopTimes, nextTripBusLocations;

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }
  
  self.stop_name = [attributes valueForKeyPath:@"stop_name"];
  self.stop_city = [attributes valueForKeyPath:@"stop_city"];
  self.stop_id = [attributes valueForKeyPath:@"stop_id"];
  self.stop_lat = [[attributes valueForKeyPath:@"stop_lat"] floatValue];
  self.stop_lon = [[attributes valueForKeyPath:@"stop_lon"] floatValue];
  self.location = [[CLLocation alloc] initWithLatitude:self.stop_lat longitude:self.stop_lon];
  
  NSString *family = [attributes valueForKeyPath:@"route_family"];
  if ([family length] > 0) {
    self.icon_path = [NSString stringWithFormat: @"icon_%@.png", family];
  }
  
  self.trip = [[Trip alloc] init];
  self.trip.trip_headsign = [attributes valueForKeyPath:@"headsign_name"];
  
  self.route = [[Route alloc] init];
  self.route.route_id = [attributes valueForKeyPath:@"route_id"];
  
  self.route.short_name = [[attributes valueForKeyPath:@"route_short_name"] intValue];
  
  if(self.stop_city == nil){
    [self fillInFromCache];
  }
  
  return self;
}

- (void) fillInFromCache {
  BusBrainAppDelegate *app = (BusBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
  Stop *cachedStop = [Stop filterStopArrayByNumber:[[app mainTableViewController] stopsDB]
                                            filter:[self stop_id]
                                          location:[[app mainTableViewController] myLocation]];
  [self setStop_city:[cachedStop stop_city]];
  [self setStop_street:[cachedStop stop_street]];
}

- (NSComparisonResult)compareLocation:(Stop *)otherObject {
  return [[self distanceFromLocation] compare:[otherObject distanceFromLocation]];
}

- (void) setRefLocation:(CLLocation *)thisLocation{
  refLocation = thisLocation;
  double dist = [[self location] distanceFromLocation:thisLocation] / 1609.344;
  [self setDistanceFromLocation:[NSNumber numberWithDouble:dist]];
}

- (void) loadNextTripTimes:(void (^)(BOOL))block {
  NSString *urlString = [NSString stringWithFormat:@"http://svc.metrotransit.org/NexTrip/%@",[self stop_id]];
  NSLog(@"URL: %@", urlString);
  
  NSDictionary *parameters = [[NSMutableDictionary alloc] init];
  [parameters setValue:@"Json" forKey:@"format"];
  
  [[TransitAPIClient sharedClient] getPath:urlString parameters:parameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
    

    NSMutableArray *nextTripTimes     = [[NSMutableArray alloc] init];
    NSMutableArray *nextTripLocations = [[NSMutableArray alloc] init];
    
    NSEnumerator *e = [JSON objectEnumerator];
    NSDictionary *attributes;
  
    while (attributes = (NSDictionary *)[e nextObject]) {
      if( [(NSNumber*)[attributes valueForKeyPath:@"Actual"] integerValue] == 1 &&
         [[attributes valueForKeyPath:@"Route"] intValue] == [[self route ] short_name] ) {
        

        
        NSString *nextTime    = [attributes valueForKeyPath:@"DepartureTime"];
        NSString *epochString = [[nextTime substringFromIndex:6] substringToIndex:13];
        NSDate   *nextDate    = [NSDate dateWithTimeIntervalSince1970:[epochString doubleValue] / 1000];
        StopTime *nextStop    = [[StopTime alloc] initWithDate:nextDate];
       
#ifdef DEBUG_BB
        NSLog(@"DEBUG: (%@) %@ -- %@, %@",
              (NSNumber*)[attributes valueForKeyPath:@"Actual"],
              [attributes valueForKeyPath:@"DepartureText"],
              (NSNumber*)[attributes valueForKeyPath:@"VehicleLatitude"],
              (NSNumber*)[attributes valueForKeyPath:@"VehicleLongitude"]);
        NSLog(@"NEXT: %@ --> %@ = %@ ",nextTime,epochString, nextDate);
#endif
        
        [nextTripTimes addObject:nextStop];
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

+ (NSArray*) filterStopArrayByRouteNumber:(NSArray*) stopArray filter:(NSString*) filterString location:(CLLocation *)location {
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

+ (Stop*) filterStopArrayByNumber:(NSArray*) stopArray filter:(NSString*) filterString location:(CLLocation *)location {
  NSString *match = [NSString stringWithFormat:@"%@", filterString];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stop_id == %@", match];
  
  NSMutableArray *resultArray = [NSMutableArray arrayWithArray:stopArray];
  [resultArray filterUsingPredicate:predicate];
  
  if([resultArray count] > 0){
    Stop *stop = [resultArray objectAtIndex:0];
    [stop setRefLocation:location];

    return stop;
  }
  
  return nil;
}

+ (void) loadNearbyStopsFromDB:(NSArray*) stopsDB near:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^)(NSDictionary *data))block {
  
  NSMutableArray *resultArray     = [[NSMutableArray alloc] init];
  NSMutableArray *topArray        = [[NSMutableArray alloc] init];
  NSMutableDictionary *lastViewed = [[NSMutableDictionary alloc] init];
  
  if(location.coordinate.latitude != 0){
    float maxDistance = 0.25f; //Miles
    while([resultArray count] < 4 && maxDistance < 25){
      
      float boxSize = maxDistance * (1.0/60.0);
      float latMax = location.coordinate.latitude + boxSize;
      float latMin = location.coordinate.latitude - boxSize;
      float lonMax = location.coordinate.longitude + boxSize;
      float lonMin = location.coordinate.longitude - boxSize;
      
      NSPredicate *predicate = [NSPredicate
                                predicateWithFormat:@"stop_lat > %f and stop_lat < %f and stop_lon > %f and stop_lon < %f",
                                latMin, latMax, lonMin, lonMax];
      
      resultArray = [NSMutableArray arrayWithArray:stopsDB];
      [resultArray filterUsingPredicate:predicate];
      
      maxDistance = maxDistance + 1.0;
    }
    
    
    NSArray *sortedArray;
    if([resultArray count] > 0) {
      NSEnumerator *e = [resultArray objectEnumerator];
      Stop *stop;
      while (stop = [e nextObject]) {
        [stop setRefLocation:location];
      }
      
      sortedArray = [resultArray sortedArrayUsingSelector:@selector(compareLocation:)];
    }
    
    if([sortedArray count] > 0) {
      [topArray addObject:[sortedArray objectAtIndex:0]];
    }
    if([sortedArray count] > 1) {
      [topArray addObject:[sortedArray objectAtIndex:1]];
    }
    if([sortedArray count] > 2) {
      [topArray addObject:[sortedArray objectAtIndex:2]];
    }
    if([sortedArray count] > 3) {
      [topArray addObject:[sortedArray objectAtIndex:3]];
    }
    
    
    //Get Last Viewed
    NSString *lastStopID = [parameters objectForKey:@"last_viewed_stop_id"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stop_id == %@", lastStopID];
    resultArray = [NSMutableArray arrayWithArray:stopsDB];
    [resultArray filterUsingPredicate:predicate];
    
    if([resultArray count] > 0){
      Stop *stop = [resultArray objectAtIndex:0];
      [stop setNextStopTime:nil];
      [lastViewed setValue:stop forKey:@"stop"];
    }
    
  }
  
  //Prepare Return
  NSMutableDictionary *data = [NSMutableDictionary dictionary];
  [data setObject:topArray forKey:@"stops"];
  [data setObject:lastViewed forKey:@"last_viewed"];
  
  if (block) {
    block([NSDictionary dictionaryWithDictionary:data]);
  }

}

- (void) loadRoutes:(void (^)(NSArray *records))block  {
  NSString *urlString = [NSString stringWithFormat:@"/bus/v2/routes.json"];
  
  NSDictionary *parameters = [[NSMutableDictionary alloc] init];
  [parameters setValue:[self stop_id] forKey:@"stop_id"];
  
  [[TransitAPIClient sharedClient] getPath:urlString parameters:parameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
    
    NSMutableArray *routes = [[NSMutableArray alloc] init];
    
    for (NSDictionary *attributes in [JSON objectEnumerator]) {
      Route *thisRoute = [[Route alloc] initWithAttributes:attributes];
      [routes addObject:thisRoute];
    }
    
    //Sort
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"short_name" ascending:YES];
    NSArray * sortedArray=[routes sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    if (block) {
      block ([NSArray arrayWithArray:sortedArray]);
    }
  } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
    if (block) {
      block ([NSArray array]);
    }
  }];
}

- (void) loadTrips:(void (^)(NSArray *records))block  {
  NSString *urlString = [NSString stringWithFormat:@"/bus/v2/trips/grouped_headsigns.json"];

  NSDate *now = [NSDate timeRightNow];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  
  NSDateComponents *components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:now];
  int hour   = [components hour];
  int minute = [components minute];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  NSString *dateString = [dateFormatter stringFromDate:now];
  
  
  NSDictionary *parameters = [[NSMutableDictionary alloc] init];
  [parameters setValue:[NSString stringWithFormat:@"%i", [[self route] short_name]] forKey:@"route_short_name"];
  [parameters setValue:[self stop_id] forKey:@"stop_id"];
  [parameters setValue:[NSString stringWithFormat:@"%@", dateString] forKey:@"date"];
  [parameters setValue:[NSString stringWithFormat:@"%d", hour] forKey:@"hour"];
  [parameters setValue:[NSString stringWithFormat:@"%d", minute] forKey:@"minute"];
  
  [[TransitAPIClient sharedClient] getPath:urlString parameters:parameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
    
    NSMutableArray *trips = [[NSMutableArray alloc] init];
    

    for (NSString *tripName in [[(NSDictionary*)JSON allKeys] objectEnumerator]) {
      NSArray* tripIDs = [(NSDictionary*)JSON objectForKey:tripName];
      
      Trip *thisTrip = [[Trip alloc] init];
      [thisTrip setTrip_headsign:tripName];
      [thisTrip setTrip_ids:tripIDs];
      [thisTrip setDate:[NSString stringWithFormat:@"%@", dateString]];
      [thisTrip setHour:[NSString stringWithFormat:@"%d", hour]];
      [thisTrip setMinute:[NSString stringWithFormat:@"%d", minute]];
      [trips addObject:thisTrip];

    }
    
    if (block) {
      block ([NSArray arrayWithArray:trips]);
    }
  } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
    if (block) {
      block ([NSArray array]);
    }
  }];
}

+ (void) loadStopsforRoute:(Route*) route block:(void (^)(NSArray *records))block  {
  NSString *urlString = [NSString stringWithFormat:@"/bus/v2/stops.json"];
  
  NSDictionary *parameters = [[NSMutableDictionary alloc] init];
  [parameters setValue:[NSString stringWithFormat:@"%i", [route short_name]] forKey:@"route_short_name"];
  
  [[TransitAPIClient sharedClient] getPath:urlString parameters:parameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
    
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    
    for (NSDictionary *attributes in [JSON objectEnumerator]) {
      Stop *thisStop = [[Stop alloc] initWithAttributes:attributes];
      [stops addObject:thisStop];
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"stop_name" ascending:YES];
    NSArray * sortedArray=[stops sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    if (block) {
      block ([NSArray arrayWithArray:sortedArray]);
    }
  } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
    if (block) {
      block ([NSArray array]);
    }
  }];
}

- (void) loadStopTimes:(void (^)(NSArray *records))block {
  
  NSString *urlString = @"/bus/v2/stop_times.json";
  
  NSDictionary *parameters = [[NSMutableDictionary alloc] init];
  [parameters setValue:[self stop_id] forKey:@"stop_id"];
  
  [parameters setValue:[[[self trip] trip_ids] componentsJoinedByString:@","] forKey:@"trip_id"];
  [parameters setValue:[[self trip] date] forKey:@"date"];
  [parameters setValue:[[self trip] hour] forKey:@"hour"];
  [parameters setValue:[[self trip] minute] forKey:@"minute"];

#ifdef DEBUG_BB
  NSLog(@"URL: %@", urlString);
  for(NSString* key in [parameters allKeys]){
    NSLog(@"  Param: %@ = %@", key, [parameters objectForKey:key]);
  }
#endif
  
  [[TransitAPIClient sharedClient] getPath:urlString parameters:parameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
    
    NSMutableArray *times = [NSMutableArray array];
    for (NSDictionary *attributes in [JSON objectEnumerator]) {
      StopTime *stop_time = [[StopTime alloc] initWithAttributes:attributes];
      
      //Cehck if stop is in the past
      if([[stop_time getStopDate] compare: [NSDate timeRightNow]] == NSOrderedDescending) {
        [times addObject:stop_time];
      }

    }
    
    if (block) {
      block ([NSArray arrayWithArray:times]);
    }
    
  } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
    if (block) {
      block ([NSArray array]);
    }
  }];
}


@end
