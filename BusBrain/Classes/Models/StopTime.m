//
//  StopTime.m
//  BusBrain
//
//  Created by Andrew Atkinson on 12/3/11.
//  Copyright 2011 Beetle Fight. All rights reserved.
//

#import "StopTime.h"
#import "TransitAPIClient.h"
#import "TimeEntry.h"
#import "NSString+BeetleFight.h"

@implementation StopTime

@synthesize departure_time, arrival_time, drop_off_type, pickup_type, price, headsign, headsign_key, departure_time_hour, departure_time_minute;

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  self.departure_time = [attributes valueForKeyPath:@"departure_time"];
  self.arrival_time = [attributes valueForKeyPath:@"arrival_time"];
  self.drop_off_type = [attributes valueForKeyPath:@"drop_off_type"];
  self.pickup_type = [attributes valueForKeyPath:@"pickup_type"];
  self.price = [attributes valueForKeyPath:@"price"];
  self.headsign = [attributes valueForKey:@"headsign"];
  self.headsign_key = [attributes valueForKey:@"headsign_key"];
  self.departure_time_hour = [self.departure_time hourFromDepartureString];
  self.departure_time_minute = [self.departure_time minuteFromDepartureString];

  return self;
}

- (NSDate*) getStopDate {
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:[NSDate date]];
  [components setHour:self.departure_time_hour];
  [components setMinute:self.departure_time_minute];
  [components setSecond:0];

  NSDate *stopDate = [gregorian dateFromComponents:components];
  [gregorian release];

  return stopDate;
}

- (NSArray*) getTimeTillDeparture {
  NSDate *currentDate = [NSDate date];
  NSDate *stopDate    = [self getStopDate];

  NSTimeInterval timeInterval;
  if([stopDate compare: currentDate] == NSOrderedDescending) {
    timeInterval = [stopDate timeIntervalSinceDate:currentDate];
  } else {
    timeInterval = 0;
  }

  NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];

  NSCalendar *calendar = [NSCalendar currentCalendar];
  [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
  NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:timerDate];
  NSInteger hour    = [components hour];
  NSInteger minute  = [components minute];
  NSInteger seconds = [components second];

  NSArray *timeArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:timeInterval],
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
  
  NSString *urlString = [NSString stringWithFormat:@"train/v1/routes/%@/stops/%@/stop_times", route_id, stop_id];
  
  NSDate *now = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
  int hour = [components hour];
  NSDictionary *params = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", hour] forKey:@"hour"];
  
  NSDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:params];

  [[TransitAPIClient sharedClient] getPath:urlString parameters:mutableParameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {

     NSMutableArray *mutableRecords = [NSMutableArray array];
     for (NSDictionary *attributes in [JSON valueForKeyPath:@"stop_times"]) {
       StopTime *stop_time = [[[StopTime alloc] initWithAttributes:attributes] autorelease];

       //Cehck if stop is in the past
       if([[stop_time getStopDate] compare: [NSDate date]] == NSOrderedDescending) {
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
    StopTime *st = [[[StopTime alloc] initWithAttributes:attributes] autorelease];
    [mutableRecords addObject:st];
  }

  return mutableRecords;
}

@end
