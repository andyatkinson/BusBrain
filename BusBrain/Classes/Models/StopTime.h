//
//  StopTime.h
//  BusBrain
//
//  Created by Andrew Atkinson on 12/3/11.
//  Copyright 2011 Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface StopTime : NSObject {
  NSString *departure_time;
  NSString *arrival_time;
  NSString *drop_off_type;
  NSString *pickup_type;
  NSString *price;
  NSString *headsign;
  NSString *headsign_key;
  int departure_time_hour;
  int departure_time_minute;
}

@property (nonatomic, retain) NSString *departure_time;
@property (nonatomic, assign) int departure_time_hour;
@property (nonatomic, assign) int departure_time_minute;
@property (nonatomic, retain) NSString *arrival_time;
@property (nonatomic, retain) NSString *drop_off_type;
@property (nonatomic, retain) NSString *pickup_type;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *headsign;
@property (nonatomic, retain) NSString *headsign_key;

- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)stopTimesWithURLString:(NSString *)urlString near:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^) (NSArray *records))block;
+ (void)stopTimesSimple:(NSString *)urlString near:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^) (NSArray *records))block;
+ (NSArray *)stopTimesFromArray:(NSArray *)array;
- (NSDate*) getStopDate;
- (NSArray*) getTimeTillDeparture;

@end
