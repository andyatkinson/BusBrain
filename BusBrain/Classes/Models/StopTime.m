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
@synthesize arrivalTime         = _arrivalTime;
@synthesize dropOffType         = _dropOffType;
@synthesize pickupType          = _pickupType;
@synthesize price               = _price;
@synthesize headsign            = _headsign;
@synthesize departureTimeHour   = _departureTimeHour;
@synthesize departureTimeMinute = _departureTimeMinute;
@synthesize departureTimeYear   = _departureTimeYear;
@synthesize departureTimeMonth  = _departureTimeMonth;
@synthesize departureTimeDay    = _departureTimeDay;

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  [self setDepartureDate: [attributes valueForKeyPath:@"departure_date"]];
  if([self departureDate] == nil){
    [self setDepartureDate:[NSDate dateRightNow]];
  }
  
  [self setDepartureTime: [attributes valueForKeyPath:@"departure_time"]];
  [self setArrivalTime: [attributes valueForKeyPath:@"arrival_time"]];
  [self setDropOffType: [attributes valueForKeyPath:@"drop_off_type"]];
  [self setPickupType: [attributes valueForKeyPath:@"pickup_type"]];
  [self setPrice: [attributes valueForKeyPath:@"price"]];
  [self setHeadsign: [attributes valueForKey:@"headsign"]];
  
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

+ (void)stopTimesSimple:(NSString *) route_id
                   stop:(NSString *) stop_id
                   near:(CLLocation *)location 
                  block:(void (^)(NSArray *records))block {
  
  NSString *urlString = [NSString stringWithFormat:@"bus/v1/routes/%@/stops/%@/stop_times.json", route_id, stop_id];

  NSDate *now = [NSDate timeRightNow];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  
  NSDateComponents *components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:now];
  int hour   = [components hour];
  int minute = [components minute];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  NSString *dateString = [dateFormatter stringFromDate:now];
  
  NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", hour],
                                                              [NSString stringWithFormat:@"%d", minute],
                                                              [NSString stringWithFormat:@"%@", dateString],
                                                              nil]
                                                     forKeys:[NSArray arrayWithObjects:@"hour", @"minute", @"date", nil] ];
  /*
  NSLog(@"URL: %@", urlString);
  for(NSString* key in [params allKeys]){
    NSLog(@"DEBUG: %@ = %@", key, [params objectForKey:key]);
  }
  */
  
  NSDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:params];

  [[TransitAPIClient sharedClient] getPath:urlString parameters:mutableParameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {

     NSMutableArray *mutableRecords = [NSMutableArray array];
     for (NSDictionary *attributes in [JSON valueForKeyPath:@"stop_times"]) {
       StopTime *stop_time = [[StopTime alloc] initWithAttributes:attributes];

       //Cehck if stop is in the past
       if([[stop_time getStopDate] compare: [NSDate timeRightNow]] == NSOrderedDescending) {
         [mutableRecords addObject:stop_time];
       }

     }

     if (block) {
       block ([NSArray arrayWithArray:mutableRecords]);
     }
   } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
     if (block) {
       block ([NSArray array]);
     }
   }];
}

+ (NSArray *)stopTimesFromArray:(NSArray *)array {
  NSMutableArray *mutableRecords = [NSMutableArray array];
  for (NSDictionary *attributes in array) {
    StopTime *st = [[StopTime alloc] initWithAttributes:attributes];
    [mutableRecords addObject:st];
  }

  return mutableRecords;
}


@end
