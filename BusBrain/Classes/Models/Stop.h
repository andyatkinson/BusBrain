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

@interface Stop : NSObject {
  NSString   *number;
  NSString   *name;
  NSString   *street;
  NSString   *lat;
  NSString   *lon;
  NSString   *city;
  NSString   *desc;
  CLLocation *location;
  CLLocation *refLocation;
  NSNumber   *distanceFromLocation;
  NSString   *iconPath;
  NSString   *headsignKey;
  Route      *route;
  StopTime   *nextStopTime;
}

@property (nonatomic, retain) NSString   *number;
@property (nonatomic, retain) NSString   *name;
@property (nonatomic, retain) NSString   *street;
@property (nonatomic, retain) NSString   *lat;
@property (nonatomic, retain) NSString   *lon;
@property (nonatomic, retain) NSString   *city;
@property (nonatomic, retain) NSString   *desc;
@property (nonatomic, retain) NSString   *iconPath;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) CLLocation *refLocation;
@property (nonatomic, retain) NSNumber   *distanceFromLocation;
@property (nonatomic, retain) NSString   *headsignKey;
@property (nonatomic, retain) Route      *route;
@property (nonatomic, retain) StopTime   *nextStopTime;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (NSArray *) stopsFromArray:(NSArray *)array;
+ (NSArray *) filterStopArray:(NSArray*) stopArray filter:(NSString*) filterString location:(CLLocation *)location;
+ (void) loadStopsDB:(void (^)(NSArray *records))block;
+ (void) nearbyStops:(CLLocation *)location block:(void (^) (NSArray *records))block;
+ (void) getStops:(NSString *)route_id stop_id:(NSString *)stop_id block:(void (^)(NSArray *records))block;
+ (void) stopsWithHeadsigns:(NSString *)urlString near:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^) (NSDictionary *data))block;
- (void) loadNextStopTime;
- (void) loadRoute:(NSString*)route_id;

@end
