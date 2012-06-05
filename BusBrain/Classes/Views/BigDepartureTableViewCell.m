//
//  BigDepartureTableViewCell.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "BusTableCell.h"
#import "BigDepartureTableViewCell.h"
#import "StopTime.h"

@implementation BigDepartureTableViewCell

@synthesize countDownTimer          = _countDownTimer;
@synthesize countDownStartDate      = _countDownStartDate;
@synthesize stopTime                = _stopTime;
@synthesize bigDepartureHour        = _bigDepartureHour;
@synthesize bigDepartureMinute      = _bigDepartureMinute;
@synthesize bigDepartureSeconds     = _bigDepartureSeconds;
@synthesize bigDepartureHourUnit    = _bigDepartureHourUnit;
@synthesize bigDepartureMinuteUnit  = _bigDepartureMinuteUnit;
@synthesize bigDepartureSecondsUnit = _bigDepartureSecondsUnit;
@synthesize funnySaying;
@synthesize description;
@synthesize formattedTime;
@synthesize price;

- (void) setStopTime: (StopTime*) stopTime {
  _stopTime = stopTime;

  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"hh:mm a"];
  [[self formattedTime] setText: [dateFormatter stringFromDate:[[self stopTime] getStopDate]]];
  [[self price] setText: [stopTime price]];

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
  NSNumber *hour    = (NSNumber*) [departureData objectAtIndex:1];
  NSNumber *minute  = (NSNumber*) [departureData objectAtIndex:2];
  NSNumber *seconds = (NSNumber*) [departureData objectAtIndex:3];

  if([timeTillDeparture intValue] > 0) {
    [self setTimerColor:[UIColor whiteColor]];
  } else {
    [self setTimerColor:[UIColor redColor]];
  }

  [[self bigDepartureHour] setText: [NSString stringWithFormat:@"%02d", [hour intValue]]];
  [[self bigDepartureMinute] setText: [NSString stringWithFormat:@"%02d", [minute intValue]]];
  [[self bigDepartureSeconds] setText: [NSString stringWithFormat:@"%02d", [seconds intValue]]];

  if([hour intValue] == 0) {
    [self layoutTimer:false];
  } else {
    [self layoutTimer:true];
  }

}

- (void) stopTimer {
  [[self countDownTimer] invalidate];
  [self setCountDownTimer: nil];
}

#pragma mark -
#pragma mark Table Methods

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    UIView *contentView = [self contentView];

    UIImage *img = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"bg_timer" ofType:@"png"]];

    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [imgView setUserInteractionEnabled:NO];
    [self setBackgroundView: imgView];

    [self setBigDepartureHour        : [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:70.0 bold:YES]];
    [self setBigDepartureMinute      : [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:70.0 bold:YES]];
    [self setBigDepartureSeconds     : [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:70.0 bold:YES]];
    [self setBigDepartureHourUnit    : [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:30.0 bold:YES]];
    [self setBigDepartureMinuteUnit  : [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:30.0 bold:YES]];
    [self setBigDepartureSecondsUnit : [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:30.0 bold:YES]];

    [self addShadow:[self bigDepartureHour]];
    [self addShadow:[self bigDepartureMinute]];
    [self addShadow:[self bigDepartureSeconds]];
    [self addShadow:[self bigDepartureHourUnit]];
    [self addShadow:[self bigDepartureMinuteUnit]];
    [self addShadow:[self bigDepartureSecondsUnit]];

    [self setFunnySaying   : [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:14.0 bold:YES]];
    [self setDescription   : [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:YES]];
    [self setFormattedTime : [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:NO]];
    [self setPrice         : [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:NO]];

    [contentView addSubview:[self bigDepartureHour]];
    [contentView addSubview:[self bigDepartureMinute]];
    [contentView addSubview:[self bigDepartureSeconds]];
    [contentView addSubview:[self bigDepartureHourUnit]];
    [contentView addSubview:[self bigDepartureMinuteUnit]];
    [contentView addSubview:[self bigDepartureSecondsUnit]];

    [contentView addSubview:[self funnySaying]];
    [contentView addSubview:[self description]];
    [contentView addSubview:[self formattedTime]];
    [contentView addSubview:[self price]];

    [[self bigDepartureHour] release];
    [[self bigDepartureMinute] release];
    [[self bigDepartureSeconds] release];
    [[self funnySaying] release];
    [[self description] release];
    [[self formattedTime] release];
    [[self price] release];

    [self setTimerColor:[UIColor whiteColor]];

    [[self bigDepartureHour]        setText : @"00"];
    [[self bigDepartureMinute]      setText : @"00"];
    [[self bigDepartureSeconds]     setText : @"00"];
    [[self bigDepartureHourUnit]    setText : @"h"];
    [[self bigDepartureMinuteUnit]  setText : @"m"];
    [[self bigDepartureSecondsUnit] setText : @"s"];

  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void) setData:(NSDictionary *)dict {
  [[self bigDepartureHour] setText: [dict objectForKey:@"title"]];
}

- (void) setTimerColor:(UIColor*) thisColor {
  [[self bigDepartureHour] setTextColor:thisColor];
  [[self bigDepartureHourUnit] setTextColor:thisColor];
  [[self bigDepartureMinute] setTextColor:thisColor];
  [[self bigDepartureMinuteUnit] setTextColor:thisColor];
  [[self bigDepartureSeconds] setTextColor:thisColor];
  [[self bigDepartureSecondsUnit] setTextColor:thisColor];

  [[self bigDepartureHour] setHighlightedTextColor:thisColor];
  [[self bigDepartureHourUnit] setHighlightedTextColor:thisColor];
  [[self bigDepartureMinute] setHighlightedTextColor:thisColor];
  [[self bigDepartureMinuteUnit] setHighlightedTextColor:thisColor];
  [[self bigDepartureSeconds] setHighlightedTextColor:thisColor];
  [[self bigDepartureSecondsUnit] setHighlightedTextColor:thisColor];
}

- (void) layoutTimer:(BOOL) showHours {
  CGRect contentRect = [[self contentView] bounds];
  CGFloat boundsX    = contentRect.origin.x;

  if (showHours) {
    [[self bigDepartureHour]        setFrame: CGRectMake(boundsX +  10,   0, 300, 100)];
    [[self bigDepartureHourUnit]    setFrame: CGRectMake(boundsX +  88,  40, 300, 100)];
    [[self bigDepartureMinute]      setFrame: CGRectMake(boundsX + 108,   0, 300, 100)];
    [[self bigDepartureMinuteUnit]  setFrame: CGRectMake(boundsX + 185,  40, 300, 100)];
    [[self bigDepartureSeconds]     setFrame: CGRectMake(boundsX + 214,   0, 300, 100)];
    [[self bigDepartureSecondsUnit] setFrame: CGRectMake(boundsX + 290,  40, 300, 100)];
  } else {
    [[self bigDepartureHour]        setFrame: CGRectMake(boundsX - 100,   0, 300, 100)];
    [[self bigDepartureHourUnit]    setFrame: CGRectMake(boundsX - 100,  40, 300, 100)];
    [[self bigDepartureMinute]      setFrame: CGRectMake(boundsX +  40,   0, 300, 100)];
    [[self bigDepartureMinuteUnit]  setFrame: CGRectMake(boundsX + 118,  40, 300, 100)];
    [[self bigDepartureSeconds]     setFrame: CGRectMake(boundsX + 154,   0, 300, 100)];
    [[self bigDepartureSecondsUnit] setFrame: CGRectMake(boundsX + 232,  40, 300, 100)];
  }

}

- (void)layoutSubviews {

  [super layoutSubviews];

  // getting the cell size
  CGRect contentRect = [[self contentView] bounds];

  // In this example we will never be editing, but this illustrates the appropriate pattern
  [self layoutTimer:false];

  // get the X pixel spot
  CGFloat boundsX = contentRect.origin.x;
  [[self funnySaying]   setFrame: CGRectMake(boundsX +  20,  98, 200,  20)];
  [[self description]   setFrame: CGRectMake(boundsX +  20, 115, 200,  20)];
  [[self formattedTime] setFrame: CGRectMake(boundsX + 250,  95,  80,  20)];
  [[self price]         setFrame: CGRectMake(boundsX + 250, 115,  80,  20)];
}

#pragma mark -
#pragma mark Cleanup Methods

- (void)dealloc {
  [_bigDepartureHour dealloc];
  [_bigDepartureMinute dealloc];
  [_bigDepartureSeconds dealloc];
  [_bigDepartureHourUnit dealloc];
  [_bigDepartureMinuteUnit dealloc];
  [_bigDepartureSecondsUnit dealloc];

  [_funnySaying dealloc];
  [_description dealloc];
  [_formattedTime dealloc];
  [_price dealloc];

  [_countDownTimer dealloc];
  [_countDownStartDate dealloc];
  [_stopTime dealloc];

  [super dealloc];
}

@end
