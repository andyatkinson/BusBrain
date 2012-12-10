//
//  NSString+BeetleFight.h
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (BeetleFight)

- (NSString *)relativeTimeHourAndMinute;
- (NSString *)hourMinuteFormatted;
- (int)hourFromDepartureString;
- (int)minuteFromDepartureString;
- (int)yearFromDepartureString;
- (int)monthFromDepartureString;
- (int)dayFromDepartureString;

@end
