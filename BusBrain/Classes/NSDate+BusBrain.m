//
//  NSDate+BusBrain.m
//  BusBrain
//
//  Created by John Doll on 12/17/12.
//
//

#import "NSDate+BusBrain.h"

@implementation NSDate (BusBrain)

+ (NSDate *) timeRightNow {
  
  /*
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components = [gregorian components:NSYearCalendarUnit |
                                  NSMonthCalendarUnit |
                                  NSDayCalendarUnit |
                                  NSHourCalendarUnit |
                                  NSMinuteCalendarUnit|
                                  NSSecondCalendarUnit
                                              fromDate:[NSDate date]];
  
  [components setYear:2012];
  [components setMonth:12];
  [components setDay:17];
  [components setHour:16];
  [components setMinute:30];
  
  NSDate *thisDate = [gregorian dateFromComponents:components];
  [gregorian release];
  return thisDate;
  
  */
  
  return [NSDate date];
  
}
@end
