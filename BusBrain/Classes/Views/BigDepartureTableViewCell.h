//
//  BigDepartureTableViewCell.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopTime.h"

@interface BigDepartureTableViewCell : UITableViewCell {
  UILabel *bigDepartureHour;
  UILabel *bigDepartureMinute;
  UILabel *bigDepartureSeconds;
  UILabel *bigDepartureHourUnit;
  UILabel *bigDepartureMinuteUnit;
  UILabel *bigDepartureSecondsUnit;
  UILabel *funnySaying;
  UILabel *description;
  UILabel *formattedTime;
  UILabel *price;

  NSTimer  *_countDownTimer;
  NSDate   *_countDownStartDate;
  StopTime *_stopTime;
}

@property (nonatomic, retain) NSTimer   *countDownTimer;
@property (nonatomic, retain) NSDate    *countDownStartDate;
@property (nonatomic, retain) StopTime  *stopTime;
@property (nonatomic, retain) UILabel   *bigDepartureHour;
@property (nonatomic, retain) UILabel   *bigDepartureMinute;
@property (nonatomic, retain) UILabel   *bigDepartureSeconds;
@property (nonatomic, retain) UILabel   *bigDepartureHourUnit;
@property (nonatomic, retain) UILabel   *bigDepartureMinuteUnit;
@property (nonatomic, retain) UILabel   *bigDepartureSecondsUnit;
@property (nonatomic, retain) UILabel   *funnySaying;
@property (nonatomic, retain) UILabel   *description;
@property (nonatomic, retain) UILabel   *formattedTime;
@property (nonatomic, retain) UILabel   *price;


// these are the functions we will create in the .m file

- (void) startTimer;
- (void) setStopTime: (StopTime*) stopTime;
- (void) layoutTimer:(BOOL) showHours;
- (void) setTimerColor:(UIColor*) thisColor;

// gets the data from another class
-(void)setData:(NSDictionary *)dict;

// internal function to ease setting up label text
-(UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@end
