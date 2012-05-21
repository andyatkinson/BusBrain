//
//  NSString+BeetleFight.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (BeetleFight)

- (NSString *)relativeTimeHourAndMinute;
- (NSString *)hourMinuteFormatted;
- (int)hourFromDepartureString;
- (int)minuteFromDepartureString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
