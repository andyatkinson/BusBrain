//
//  BigDepartureTableViewCell.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "BusLooknFeel.h"
#import "CountDownView.h"
#import "StopTime.h"

@implementation CountDownView

@synthesize countDownTimer          = _countDownTimer;
@synthesize countDownStartDate      = _countDownStartDate;
@synthesize stopTime                = _stopTime;
@synthesize bigDepartureDays        = _bigDepartureDays;
@synthesize bigDepartureHour        = _bigDepartureHour;
@synthesize bigDepartureMinute      = _bigDepartureMinute;
@synthesize bigDepartureSeconds     = _bigDepartureSeconds;
@synthesize bigDepartureDaysUnit    = _bigDepartureDaysUnit;
@synthesize bigDepartureHourUnit    = _bigDepartureHourUnit;
@synthesize bigDepartureMinuteUnit  = _bigDepartureMinuteUnit;
@synthesize bigDepartureSecondsUnit = _bigDepartureSecondsUnit;
@synthesize funnySaying;
@synthesize description;
@synthesize formattedTime;
@synthesize nextTripTime;
@synthesize price;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    UIImage *img = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"bg_timer" ofType:@"png"]];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:img]];
    
    [self setBigDepartureDays        : [self newLabelWithPrimaryColor:[BusLooknFeel getTimerColor]
                                                        selectedColor:[BusLooknFeel getTimerColor]
                                                                 font:[BusLooknFeel getTimerBigFont]]];
    
    [self setBigDepartureHour        : [self newLabelWithPrimaryColor:[BusLooknFeel getTimerColor]
                                                        selectedColor:[BusLooknFeel getTimerColor]
                                                                 font:[BusLooknFeel getTimerBigFont]]];
    
    [self setBigDepartureMinute      : [self newLabelWithPrimaryColor:[BusLooknFeel getTimerColor]
                                                        selectedColor:[BusLooknFeel getTimerColor]
                                                                 font:[BusLooknFeel getTimerBigFont]]];
    
    [self setBigDepartureSeconds     : [self newLabelWithPrimaryColor:[BusLooknFeel getTimerColor]
                                                        selectedColor:[BusLooknFeel getTimerColor]
                                                                 font:[BusLooknFeel getTimerBigFont]]];
    
    
    [self setBigDepartureDaysUnit    : [self newLabelWithPrimaryColor:[BusLooknFeel getTimerColor]
                                                        selectedColor:[BusLooknFeel getTimerColor]
                                                                 font:[BusLooknFeel getTimerSmallFont]]];
    
    [self setBigDepartureHourUnit    : [self newLabelWithPrimaryColor:[BusLooknFeel getTimerColor]
                                                        selectedColor:[BusLooknFeel getTimerColor]
                                                                 font:[BusLooknFeel getTimerSmallFont]]];
    
    [self setBigDepartureMinuteUnit  : [self newLabelWithPrimaryColor:[BusLooknFeel getTimerColor]
                                                        selectedColor:[BusLooknFeel getTimerColor]
                                                                 font:[BusLooknFeel getTimerSmallFont]]];
    
    [self setBigDepartureSecondsUnit : [self newLabelWithPrimaryColor:[BusLooknFeel getTimerColor]
                                                        selectedColor:[BusLooknFeel getTimerColor]
                                                                 font:[BusLooknFeel getTimerSmallFont]]];
    
    
    [BusLooknFeel addShadow:[self bigDepartureDays]        color:[BusLooknFeel getTimerShadowColor] height:2.0];
    [BusLooknFeel addShadow:[self bigDepartureHour]        color:[BusLooknFeel getTimerShadowColor] height:2.0];
    [BusLooknFeel addShadow:[self bigDepartureMinute]      color:[BusLooknFeel getTimerShadowColor] height:2.0];
    [BusLooknFeel addShadow:[self bigDepartureSeconds]     color:[BusLooknFeel getTimerShadowColor] height:2.0];
    [BusLooknFeel addShadow:[self bigDepartureDaysUnit]    color:[BusLooknFeel getTimerShadowColor] height:2.0];
    [BusLooknFeel addShadow:[self bigDepartureHourUnit]    color:[BusLooknFeel getTimerShadowColor] height:2.0];
    [BusLooknFeel addShadow:[self bigDepartureMinuteUnit]  color:[BusLooknFeel getTimerShadowColor] height:2.0];
    [BusLooknFeel addShadow:[self bigDepartureSecondsUnit] color:[BusLooknFeel getTimerShadowColor] height:2.0];
    
    
    [self setFunnySaying   : [self newLabelWithPrimaryColor:[BusLooknFeel getTimerTitleColor]
                                              selectedColor:[BusLooknFeel getTimerTitleColor]
                                                       font:[BusLooknFeel getTimerTitleFont]]];
    
    [self setDescription   : [self newLabelWithPrimaryColor:[BusLooknFeel getTimerSubTitleColor]
                                              selectedColor:[BusLooknFeel getTimerSubTitleColor]
                                                       font:[BusLooknFeel getTimerSubTitleFont]]];
    
    [self setFormattedTime : [self newLabelWithPrimaryColor:[BusLooknFeel getTimerDetailColor]
                                              selectedColor:[BusLooknFeel getTimerDetailColor]
                                                       font:[BusLooknFeel getTimerDetailFont]]];
    
    [self setNextTripTime  : [self newLabelWithPrimaryColor:[BusLooknFeel getTimerDetailColor]
                                              selectedColor:[BusLooknFeel getTimerDetailColor]
                                                       font:[BusLooknFeel getTimerDetailFont]]];
    
    [self setPrice         : [self newLabelWithPrimaryColor:[BusLooknFeel getTimerDetailColor]
                                              selectedColor:[BusLooknFeel getTimerDetailColor]
                                                       font:[BusLooknFeel getTimerDetailFont]]];
    
    [self addSubview:[self bigDepartureDays]];
    [self addSubview:[self bigDepartureHour]];
    [self addSubview:[self bigDepartureMinute]];
    [self addSubview:[self bigDepartureSeconds]];
    [self addSubview:[self bigDepartureDaysUnit]];
    [self addSubview:[self bigDepartureHourUnit]];
    [self addSubview:[self bigDepartureMinuteUnit]];
    [self addSubview:[self bigDepartureSecondsUnit]];
    
    [self addSubview:[self funnySaying]];
    [self addSubview:[self description]];
    [self addSubview:[self formattedTime]];
    [self addSubview:[self nextTripTime]];
    [self addSubview:[self price]];
    
    [self bigDepartureDays];
    [self bigDepartureHour];
    [self bigDepartureMinute];
    [self bigDepartureSeconds];
    [self funnySaying];
    [self description];
    [self formattedTime];
    [self nextTripTime];
    [self price];
    
    [self setTimerColor:[BusLooknFeel getTimerColor]];
    
    [[self bigDepartureDays]        setText : @""];
    [[self bigDepartureHour]        setText : @""];
    [[self bigDepartureMinute]      setText : @""];
    [[self bigDepartureSeconds]     setText : @""];
    [[self bigDepartureDaysUnit]    setText : @"d"];
    [[self bigDepartureHourUnit]    setText : @"h"];
    [[self bigDepartureMinuteUnit]  setText : @"m"];
    [[self bigDepartureSecondsUnit] setText : @"s"];
    
  }
  return self;
}

- (OHAttributedLabel *)newLabelWithPrimaryColor:(UIColor *) primaryColor
                                  selectedColor:(UIColor *) selectedColor
                                       fontSize:(CGFloat) fontSize
                                           bold:(BOOL) bold {
  
  UIFont *font;
  if (bold) {
    font = [UIFont boldSystemFontOfSize:fontSize];
  } else {
    font = [UIFont systemFontOfSize:fontSize];
  }
  
  OHAttributedLabel *newLabel = [self newLabelWithPrimaryColor:primaryColor selectedColor:selectedColor font: font];
  return newLabel;
}

- (OHAttributedLabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor
                                  selectedColor:(UIColor *)selectedColor
                                           font:(UIFont *) font {
  
  /*
   Views are drawn most efficiently when they are opaque and do not have a clear background,
   so set these defaults.  To show selection properly, however, the views need to be transparent
   (so that the selection color shows through).  This is handled in setSelected:animated:.
   */
  OHAttributedLabel *newLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
  [newLabel setBackgroundColor: [UIColor clearColor]];
  [newLabel setOpaque: YES];
  [newLabel setTextColor: primaryColor];
  [newLabel setHighlightedTextColor: selectedColor];
  [newLabel setFont: font];
  
  return newLabel;
}

- (void) setStopTime: (StopTime*) stopTime {
  _stopTime = stopTime;

  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"hh:mm a"];
  [[self formattedTime] setText: [dateFormatter stringFromDate:[[self stopTime] getStopDate]]];
  [[self nextTripTime] setText:@"NexTrip"];
  [[self price] setText: @""];

}

- (void) startTimer {
  if([self countDownTimer] == nil) {
    [self setCountDownStartDate:[NSDate date]];

    // Create the stop watch timer that fires every 1 s
    [self setCountDownTimer: [NSTimer scheduledTimerWithTimeInterval:1.0
                              target:self
                              selector:@selector(updateTimer)
                              userInfo:nil
                              repeats:YES]];
  }
}

#pragma mark -
#pragma mark Countdown Timer Methods

- (void)updateTimer {
  NSArray  *departureData = [[self stopTime] getTimeTillDeparture];
  NSNumber *timeTillDeparture = (NSNumber*) [departureData objectAtIndex:0];
  NSNumber *days    = (NSNumber*) [departureData objectAtIndex:1];
  NSNumber *hour    = (NSNumber*) [departureData objectAtIndex:2];
  NSNumber *minute  = (NSNumber*) [departureData objectAtIndex:3];
  NSNumber *seconds = (NSNumber*) [departureData objectAtIndex:4];

  if([timeTillDeparture intValue] > 0) {
    [self setTimerColor:[BusLooknFeel getTimerColor]];
  } else {
    [self setTimerColor:[BusLooknFeel getTimerZeroColor]];
  }

  [[self bigDepartureDays] setText: [NSString stringWithFormat:@"%02d", [days intValue]]];
  [[self bigDepartureHour] setText: [NSString stringWithFormat:@"%02d", [hour intValue]]];
  [[self bigDepartureMinute] setText: [NSString stringWithFormat:@"%02d", [minute intValue]]];
  [[self bigDepartureSeconds] setText: [NSString stringWithFormat:@"%02d", [seconds intValue]]];

  if([days intValue] > 0) {
    [self layoutTimer:YES showDays:YES];
  } else if([hour intValue] > 0) {
    [self layoutTimer:YES showDays:NO];
  } else {
    [self layoutTimer:NO showDays:NO];
  }

}

- (void) stopTimer {
  [[self countDownTimer] invalidate];
  [self setCountDownTimer: nil];
}


- (void) setData:(NSDictionary *)dict {
  [[self bigDepartureHour] setText: [dict objectForKey:@"title"]];
}

- (void) setTimerColor:(UIColor*) thisColor {
  [[self bigDepartureDays]        setTextColor:thisColor];
  [[self bigDepartureDaysUnit]    setTextColor:thisColor];
  [[self bigDepartureHour]        setTextColor:thisColor];
  [[self bigDepartureHourUnit]    setTextColor:thisColor];
  [[self bigDepartureMinute]      setTextColor:thisColor];
  [[self bigDepartureMinuteUnit]  setTextColor:thisColor];
  [[self bigDepartureSeconds]     setTextColor:thisColor];
  [[self bigDepartureSecondsUnit] setTextColor:thisColor];

  [[self bigDepartureDays]        setHighlightedTextColor:thisColor];
  [[self bigDepartureDaysUnit]    setHighlightedTextColor:thisColor];
  [[self bigDepartureHour]        setHighlightedTextColor:thisColor];
  [[self bigDepartureHourUnit]    setHighlightedTextColor:thisColor];
  [[self bigDepartureMinute]      setHighlightedTextColor:thisColor];
  [[self bigDepartureMinuteUnit]  setHighlightedTextColor:thisColor];
  [[self bigDepartureSeconds]     setHighlightedTextColor:thisColor];
  [[self bigDepartureSecondsUnit] setHighlightedTextColor:thisColor];
}

- (void) layoutTimer:(BOOL) showHours showDays:(BOOL) showDays{
  CGRect contentRect = [self bounds];
  CGFloat boundsX    = contentRect.origin.x;
  
  if(showDays || showHours){
    //Hide Seconds
    [[self bigDepartureSeconds]     setFrame: CGRectMake(boundsX - 100,   0, 300, 100)];
    [[self bigDepartureSecondsUnit] setFrame: CGRectMake(boundsX - 100,  45, 300, 100)];
  } else {
    //Show Seconds
    [[self bigDepartureSeconds]     setFrame: CGRectMake(boundsX + 164,   0, 300, 100)];
    [[self bigDepartureSecondsUnit] setFrame: CGRectMake(boundsX + 247,  45, 300, 100)];
  }
  
  if(showDays){
    //Hide Minute
    [[self bigDepartureMinute]     setFrame: CGRectMake(boundsX - 100,   0, 300, 100)];
    [[self bigDepartureMinuteUnit] setFrame: CGRectMake(boundsX - 100,  45, 300, 100)];
  } else {
    //Hide Day
    [[self bigDepartureDays]     setFrame: CGRectMake(boundsX - 100,   0, 300, 100)];
    [[self bigDepartureDaysUnit] setFrame: CGRectMake(boundsX - 100,  45, 300, 100)];
  }
  
  if(showDays){
    [[self bigDepartureDays]        setFrame: CGRectMake(boundsX +  44,   0, 300, 100)];
    [[self bigDepartureDaysUnit]    setFrame: CGRectMake(boundsX + 127,  45, 300, 100)];
    
    [[self bigDepartureHour]      setFrame: CGRectMake(boundsX + 154,   0, 300, 100)];
    [[self bigDepartureHourUnit]  setFrame: CGRectMake(boundsX + 239,  45, 300, 100)];
    
  } else if (showHours) {
    [[self bigDepartureHour]        setFrame: CGRectMake(boundsX +  44,   0, 300, 100)];
    [[self bigDepartureHourUnit]    setFrame: CGRectMake(boundsX + 127,  45, 300, 100)];
    
    [[self bigDepartureMinute]      setFrame: CGRectMake(boundsX + 154,   0, 300, 100)];
    [[self bigDepartureMinuteUnit]  setFrame: CGRectMake(boundsX + 239,  45, 300, 100)];
  } else {
    [[self bigDepartureHour]        setFrame: CGRectMake(boundsX - 100,   0, 300, 100)];
    [[self bigDepartureHourUnit]    setFrame: CGRectMake(boundsX - 100,  45, 300, 100)];
    
    [[self bigDepartureMinute]      setFrame: CGRectMake(boundsX +  50,   0, 300, 100)];
    [[self bigDepartureMinuteUnit]  setFrame: CGRectMake(boundsX + 133,  45, 300, 100)];
    
  }

}

- (void)layoutSubviews {

  [super layoutSubviews];

  // getting the cell size
  CGRect contentRect = [self bounds];

  // In this example we will never be editing, but this illustrates the appropriate pattern
  [self layoutTimer:NO showDays:NO];
  
  //Force everythig off screen to avoid flicker when pushing view on the stack
  [[self bigDepartureMinuteUnit] setFrame: CGRectMake(0 - 100,  45, 300, 100)];
  [[self bigDepartureSecondsUnit] setFrame: CGRectMake(0 - 100,  45, 300, 100)];

  // get the X pixel spot
  CGFloat boundsX = contentRect.origin.x;
  [[self funnySaying]   setFrame: CGRectMake(boundsX +  20,  98, 200,  20)];
  [[self description]   setFrame: CGRectMake(boundsX +  20, 115, 200,  20)];
  [[self formattedTime] setFrame: CGRectMake(boundsX + 250,  98,  80,  20)];
  [[self nextTripTime]  setFrame: CGRectMake(boundsX + 250, 118,  80,  20)];
}

#pragma mark -
#pragma mark Cleanup Methods


@end
