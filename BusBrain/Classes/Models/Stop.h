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
  NSString   *stop_id;
  NSString   *stop_name;
  NSString   *stop_street;
  NSString   *stop_lat;
  NSString   *stop_lon;
  NSString   *stop_city;
  NSString   *stop_desc;
  CLLocation *location;
  CLLocation *refLocation;
  NSNumber   *distanceFromLocation;
  NSString   *icon_path;
  NSString   *headsign_key;
  Route      *route;
  StopTime   *nextStopTime;
}

@property (nonatomic, retain) NSString   *stop_id;
@property (nonatomic, retain) NSString   *stop_name;
@property (nonatomic, retain) NSString   *stop_street;
@property (nonatomic, retain) NSString   *stop_lat;
@property (nonatomic, retain) NSString   *stop_lon;
@property (nonatomic, retain) NSString   *stop_city;
@property (nonatomic, retain) NSString   *stop_desc;
@property (nonatomic, retain) NSString   *icon_path;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) CLLocation *refLocation;
@property (nonatomic, retain) NSNumber   *distanceFromLocation;
@property (nonatomic, retain) NSString   *headsign_key;
@property (nonatomic, retain) Route      *route;
@property (nonatomic, retain) StopTime   *nextStopTime;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (NSArray *)stopsFromArray:(NSArray *)array;
+ (void) stopsFromPlist:(CLLocation *)location block:(void (^) (NSArray *records))block;
+ (void)getStops:(NSString *)route_id stop_id:(NSString *)stop_id block:(void (^)(NSArray *records))block;
+ (void)stopsWithHeadsigns:(NSString *)urlString near:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^) (NSDictionary *data))block;
- (void) loadNextStopTime;
- (void) loadRoute:(NSString*)route_id;

@end
