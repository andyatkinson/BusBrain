//
//  StopTime.m
//  BusBrain
//
//  Created by Andrew Atkinson on 12/3/11.
//  Copyright 2011 Beetle Fight. All rights reserved.
//

#import "BusBrainAppDelegate.h"
#import "StopTime.h"
#import "TransitAPIClient.h"
#import "NSString+BeetleFight.h"
#import "NSDate+BusBrain.h"

@implementation StopTime

@synthesize departureDate       = _departureDate;
@synthesize departureTime       = _departureTime;

@synthesize departureTimeHour   = _departureTimeHour;
@synthesize departureTimeMinute = _departureTimeMinute;
@synthesize departureTimeYear   = _departureTimeYear;
@synthesize departureTimeMonth  = _departureTimeMonth;
@synthesize departureTimeDay    = _departureTimeDay;

- (id)initWithDate:(NSDate *)date {
  self = [super init];
  if (!self) {
    return nil;
  }
  
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components = [gregorian components:
                                  NSYearCalendarUnit |
                                  NSMonthCalendarUnit |
                                  NSDayCalendarUnit |
                                  NSHourCalendarUnit |
                                  NSMinuteCalendarUnit
                                  fromDate:date];
  
  [self setDepartureTimeHour:   [components hour]];
  [self setDepartureTimeMinute: [components minute]];
  [self setDepartureTimeYear:   [components year]];
  [self setDepartureTimeMonth:  [components month]];
  [self setDepartureTimeDay:    [components day]];

  return self;
}


- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  
  [self setDepartureDate: [[attributes allKeys] objectAtIndex:0]];
  if([self departureDate] == nil){
    [self setDepartureDate:[NSDate dateRightNow]];
  }
  [self setDepartureTime: [[attributes allValues] objectAtIndex:0]];
  
#ifdef DEBUG_BB
  NSLog(@"DEBUG - Date: %@, Time: %@", [self departureDate], [self departureTime]);
#endif
  
  [self setDepartureTimeHour: [[self departureTime] hourFromDepartureString]];
  [self setDepartureTimeMinute: [[self departureTime] minuteFromDepartureString]];
  [self setDepartureTimeYear: [[self departureDate] yearFromDepartureString]];
  [self setDepartureTimeMonth: [[self departureDate] monthFromDepartureString]];
  [self setDepartureTimeDay: [[self departureDate] dayFromDepartureString]];
  
  if([self departureTimeHour] >= 24){
    int hour = [self departureTimeHour] - 24;
    [self setDepartureTime:[NSString stringWithFormat:@"%i:%i:00", hour, [self departureTimeMinute]] ];
  }

  return self;
}

- (NSDate*) getStopDate {
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:[NSDate date]];
  
  [components setYear:[self departureTimeYear]];
  [components setMonth:[self departureTimeMonth]];
  [components setDay:[self departureTimeDay]];
  [components setHour:[self departureTimeHour]];
  [components setMinute:[self departureTimeMinute]];
  [components setSecond:0];

  NSDate *stopDate = [gregorian dateFromComponents:components];

  return stopDate;
}

- (NSArray*) getTimeTillDeparture {
  NSDate *currentDate = [NSDate timeRightNow];
  NSDate *stopDate    = [self getStopDate];
  
  NSTimeInterval timeInterval;
  if([stopDate compare: currentDate] == NSOrderedDescending) {
    timeInterval = [stopDate timeIntervalSinceDate:currentDate];
  } else {
    timeInterval = 0;
  }

  NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
  //NSLog(@"%@ -- %@ == %@", currentDate, stopDate, timerDate);
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
  NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:timerDate];
  NSInteger days    = [components day];
  NSInteger hour    = [components hour];
  NSInteger minute  = [components minute];
  NSInteger seconds = [components second];

  NSArray *timeArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:timeInterval],
                        [NSNumber numberWithInteger:days - 1],
                        [NSNumber numberWithInteger:hour],
                        [NSNumber numberWithInteger:minute],
                        [NSNumber numberWithInteger:seconds],
                        nil];
  return timeArray;
}


@end
