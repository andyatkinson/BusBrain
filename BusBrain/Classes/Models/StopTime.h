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
  NSString *_departureTime;
  NSString *_arrivalTime;
  NSString *_dropOffType;
  NSString *_pickupType;
  NSString *_price;
  NSString *_headsign;
  NSString *_headsignKey;
  int _departureTimeHour;
  int _departureTimeMinute;
}

@property (nonatomic, retain) NSString *departureTime;
@property (nonatomic, retain) NSString *arrivalTime;
@property (nonatomic, retain) NSString *dropOffType;
@property (nonatomic, retain) NSString *pickupType;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *headsign;
@property (nonatomic, retain) NSString *headsignKey;
@property (nonatomic, assign) int departureTimeHour;
@property (nonatomic, assign) int departureTimeMinute;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)stopTimesSimple:(NSString *) route_id
                   stop:(NSString *) stop_id
                   near:(CLLocation *)location 
                  block:(void (^)(NSArray *records))block;

+ (NSArray *)stopTimesFromArray:(NSArray *)array;
- (NSDate*) getStopDate;
- (NSArray*) getTimeTillDeparture;

@end
