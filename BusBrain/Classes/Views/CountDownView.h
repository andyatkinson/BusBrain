//
//  BigDepartureTableViewCell.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopTime.h"
#import "OHAttributedLabel.h"
#import "StopTime.h"
#import "Stop.h"

@interface CountDownView : UIView {
  BOOL _dataRefreshRequested;
  
  OHAttributedLabel *_bigDepartureDays;
  OHAttributedLabel *_bigDepartureHour;
  OHAttributedLabel *_bigDepartureMinute;
  OHAttributedLabel *_bigDepartureSeconds;
  OHAttributedLabel *_bigDepartureDaysUnit;
  OHAttributedLabel *_bigDepartureHourUnit;
  OHAttributedLabel *_bigDepartureMinuteUnit;
  OHAttributedLabel *_bigDepartureSecondsUnit;
  OHAttributedLabel *_funnySaying;
  OHAttributedLabel *_description;
  OHAttributedLabel *_formattedTime;
  OHAttributedLabel *_nextTripTime;
  OHAttributedLabel *_price;

  NSTimer  *_countDownTimer;
  NSDate   *_countDownStartDate;
  StopTime *_stopTime;
}

@property (nonatomic) BOOL dataRefreshRequested;
@property (nonatomic, strong) NSTimer   *countDownTimer;
@property (nonatomic, strong) NSDate    *countDownStartDate;
@property (nonatomic, strong) StopTime  *stopTime;
@property (nonatomic, strong) OHAttributedLabel   *bigDepartureDays;
@property (nonatomic, strong) OHAttributedLabel   *bigDepartureHour;
@property (nonatomic, strong) OHAttributedLabel   *bigDepartureMinute;
@property (nonatomic, strong) OHAttributedLabel   *bigDepartureSeconds;
@property (nonatomic, strong) OHAttributedLabel   *bigDepartureDaysUnit;
@property (nonatomic, strong) OHAttributedLabel   *bigDepartureHourUnit;
@property (nonatomic, strong) OHAttributedLabel   *bigDepartureMinuteUnit;
@property (nonatomic, strong) OHAttributedLabel   *bigDepartureSecondsUnit;
@property (nonatomic, strong) OHAttributedLabel   *funnySaying;
@property (nonatomic, strong) OHAttributedLabel   *description;
@property (nonatomic, strong) OHAttributedLabel   *formattedTime;
@property (nonatomic, strong) OHAttributedLabel   *nextTripTime;
@property (nonatomic, strong) OHAttributedLabel   *price;


// these are the functions we will create in the .m file

- (void) startTimer;
- (void) setStopTime: (StopTime*) stopTime;
- (void) layoutTimer:(BOOL) showHours showDays:(BOOL) showDays;
- (void) setTimerColor:(UIColor*) thisColor;

// gets the data from another class
-(void)setData:(NSDictionary *)dict;

@end
