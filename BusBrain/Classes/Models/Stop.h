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

@interface Stop : NSObject {
  NSString *stop_id;
  NSString *stop_name;
  NSString *stop_street;
  NSString *stop_lat;
  NSString *stop_lon;
  NSString *stop_city;
  NSString *stop_desc;
  CLLocation *location;
  NSString *icon_path;
  NSString *headsign_key;
  Route *route;
}

@property (nonatomic, retain) NSString *stop_id;
@property (nonatomic, retain) NSString *stop_name;
@property (nonatomic, retain) NSString *stop_street;
@property (nonatomic, retain) NSString *stop_lat;
@property (nonatomic, retain) NSString *stop_lon;
@property (nonatomic, retain) NSString *stop_city;
@property (nonatomic, retain) NSString *stop_desc;
@property (nonatomic, retain) NSString *icon_path;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSString *headsign_key;
@property (nonatomic, retain) Route *route;

- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)stopsWithURLString:(NSString *)urlString near:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^) (NSArray *records))block;
+ (NSArray *)stopsFromArray:(NSArray *)array;

+ (void) stopsFromPlist:(void (^) (NSArray *records))block;
+ (void) stopsFromPlist:(CLLocation *)location block:(void (^) (NSArray *records))block;
+ (void)stopsWithHeadsigns:(NSString *)urlString near:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^) (NSDictionary *data))block;

@end
