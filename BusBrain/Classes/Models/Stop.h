//
//  Stop.h
//  BusBrain
//
//  Created by Andrew Atkinson on 12/3/11.
//  Copyright 2011 Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Route.h"
#import "StopTime.h"
#import "Headsign.h"

@interface Stop : NSObject {
  NSString   *stop_id;
  NSString   *stop_name;
  NSString   *stop_street;
  float       stop_lat;
  float       stop_lon;
  CLLocation *location;
  NSString   *icon_path;
  Headsign   *headsign;
  Route      *route;
  
  /* Cache users current location and save distance from
     allowing us to sort stops by nearest location
   */
  CLLocation *refLocation;
  NSNumber   *distanceFromLocation;
    
 /* Utility method to fetch the next stop time 
    This might be obsolete if all endpoints are now returning required data
  */
  StopTime   *nextStopTime;
    
  NSString   *nextTripStopID;
  NSArray    *nextTripStopTimes;
  NSArray    *nextTripBusLocations;
    
}

@property (nonatomic, strong) NSString   *stop_id;
@property (nonatomic, strong) NSString   *stop_name;
@property (nonatomic, strong) NSString   *stop_street;
@property (nonatomic) float   stop_lat;
@property (nonatomic) float   stop_lon;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString   *icon_path;
@property (nonatomic, strong) Headsign   *headsign;
@property (nonatomic, strong) Route      *route;

@property (nonatomic, strong) CLLocation *refLocation;
@property (nonatomic, strong) NSNumber   *distanceFromLocation;
@property (nonatomic, strong) StopTime   *nextStopTime;

@property (nonatomic, strong) NSString   *nextTripStopID;
@property (nonatomic, strong) NSArray    *nextTripStopTimes;
@property (nonatomic, strong) NSArray    *nextTripBusLocations;


- (id)initWithAttributes:(NSDictionary *)attributes;

+ (NSArray *) filterStopArrayByName:(NSArray*) stopArray filter:(NSString*) filterString location:(CLLocation *)location;
+ (NSArray *) filterStopArrayByNumber:(NSArray*) stopArray filter:(NSString*) filterString location:(CLLocation *)location;
+ (void) getStops:(NSString *)route_id stop_id:(NSString *)stop_id block:(void (^)(NSArray *records))block;

- (void) loadNextTripTimes:(void (^)(BOOL))block;
- (void) loadNextStopTime;
+ (void) loadNearbyStopsFromDB:(NSArray*) stopsDB near:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^)(NSDictionary *data))block;
@end
