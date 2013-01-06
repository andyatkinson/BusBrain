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

  int _departureTimeHour;
  int _departureTimeMinute;
  int _departureTimeYear;
  int _departureTimeMonth;
  int _departureTimeDay;
}

@property (nonatomic, strong) NSString *departureDate;
@property (nonatomic, strong) NSString *departureTime;

@property (nonatomic, assign) int departureTimeHour;
@property (nonatomic, assign) int departureTimeMinute;
@property (nonatomic, assign) int departureTimeYear;
@property (nonatomic, assign) int departureTimeMonth;
@property (nonatomic, assign) int departureTimeDay;

- (id)initWithAttributes:(NSDictionary *)attributes;

- (NSDate*)   getStopDate;
- (NSArray*)  getTimeTillDeparture;

@end
