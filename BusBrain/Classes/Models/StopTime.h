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
  NSString *_departureDate;
  NSString *_departureTime;
  NSString *_arrivalTime;
  NSString *_dropOffType;
  NSString *_pickupType;
  NSString *_price;
  NSString *_headsign;
  int _departureTimeHour;
  int _departureTimeMinute;
  int _departureTimeYear;
  int _departureTimeMonth;
  int _departureTimeDay;
}

@property (nonatomic, strong) NSString *departureDate;
@property (nonatomic, strong) NSString *departureTime;
@property (nonatomic, strong) NSString *arrivalTime;
@property (nonatomic, strong) NSString *dropOffType;
@property (nonatomic, strong) NSString *pickupType;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *headsign;
@property (nonatomic, assign) int departureTimeHour;
@property (nonatomic, assign) int departureTimeMinute;
@property (nonatomic, assign) int departureTimeYear;
@property (nonatomic, assign) int departureTimeMonth;
@property (nonatomic, assign) int departureTimeDay;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)stopTimesSimple:(NSString *) route_id
                   stop:(NSString *) stop_id
                   near:(CLLocation *)location 
                  block:(void (^)(NSArray *records))block;

+ (NSArray *)stopTimesFromArray:(NSArray *)array;
- (NSDate*) getStopDate;
- (NSArray*) getTimeTillDeparture;

@end
