//
//  NSString+BeetleFight.m
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "NSString+BeetleFight.h"

@implementation NSString (BeetleFight)

// Expects time strings in this format: 00:00:00, e.g. "08:10:00"

- (NSString *)relativeTimeHourAndMinute {
  NSDate *now = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
  int currentHour = (int)[components hour];
  components = [calendar components:NSMinuteCalendarUnit fromDate:now];
  int currentMinute = (int)[components minute];

  NSArray *parts = [self componentsSeparatedByString:@":"];
  int scheduleHour = (int)[[parts objectAtIndex:0] intValue];
  int scheduleMinute = (int)[[parts objectAtIndex:1] intValue];

  int relativeHour = 0;
  if (scheduleHour > currentHour) {
    relativeHour = scheduleHour - currentHour;
  }

  int relativeMinute = 0;
  if (scheduleMinute > currentMinute) {
    relativeMinute = scheduleMinute - currentMinute;
  }

  return [NSString stringWithFormat:@"%dh%dm", relativeHour, relativeMinute];
}

- (int)yearFromDepartureString {
  NSArray *parts = [self componentsSeparatedByString:@"-"];
  return (int)[[parts objectAtIndex:0] intValue];
}

- (int)monthFromDepartureString {
  NSArray *parts = [self componentsSeparatedByString:@"-"];
  return (int)[[parts objectAtIndex:1] intValue];
}

- (int)dayFromDepartureString {
  NSArray *parts = [self componentsSeparatedByString:@"-"];
  return (int)[[parts objectAtIndex:2] intValue];
}

- (int)hourFromDepartureString {
  NSArray *parts = [self componentsSeparatedByString:@":"];
  return (int)[[parts objectAtIndex:0] intValue];
}

- (int)minuteFromDepartureString {
  NSArray *parts = [self componentsSeparatedByString:@":"];
  return (int)[[parts objectAtIndex:1] intValue];
}

- (NSString *)hourMinuteFormatted {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"HH:mm:ss"];
  NSDate *date = [formatter dateFromString:self];

  [formatter setDateFormat:@"h:mm a"];

  NSString *formattedTime = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
  [formatter release];

  return formattedTime;
}

@end
