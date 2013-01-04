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
@property (nonatomic, retain) NSTimer   *countDownTimer;
@property (nonatomic, retain) NSDate    *countDownStartDate;
@property (nonatomic, retain) StopTime  *stopTime;
@property (nonatomic, retain) OHAttributedLabel   *bigDepartureDays;
@property (nonatomic, retain) OHAttributedLabel   *bigDepartureHour;
@property (nonatomic, retain) OHAttributedLabel   *bigDepartureMinute;
@property (nonatomic, retain) OHAttributedLabel   *bigDepartureSeconds;
@property (nonatomic, retain) OHAttributedLabel   *bigDepartureDaysUnit;
@property (nonatomic, retain) OHAttributedLabel   *bigDepartureHourUnit;
@property (nonatomic, retain) OHAttributedLabel   *bigDepartureMinuteUnit;
@property (nonatomic, retain) OHAttributedLabel   *bigDepartureSecondsUnit;
@property (nonatomic, retain) OHAttributedLabel   *funnySaying;
@property (nonatomic, retain) OHAttributedLabel   *description;
@property (nonatomic, retain) OHAttributedLabel   *formattedTime;
@property (nonatomic, retain) OHAttributedLabel   *nextTripTime;
@property (nonatomic, retain) OHAttributedLabel   *price;


// these are the functions we will create in the .m file

- (void) startTimer;
- (void) setStopTime: (StopTime*) stopTime;
- (void) layoutTimer:(BOOL) showHours showDays:(BOOL) showDays;
- (void) setTimerColor:(UIColor*) thisColor;

// gets the data from another class
-(void)setData:(NSDictionary *)dict;

@end
