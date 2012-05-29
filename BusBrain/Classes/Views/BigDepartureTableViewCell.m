//
//  BigDepartureTableViewCell.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "BigDepartureTableViewCell.h"
#import "StopTime.h"

@implementation BigDepartureTableViewCell

@synthesize countDownTimer     = _countDownTimer;
@synthesize countDownStartDate = _countDownStartDate;
@synthesize stopTime           = _stopTime;
@synthesize bigDepartureHour, bigDepartureMinute, bigDepartureSeconds;
@synthesize bigDepartureHourUnit, bigDepartureMinuteUnit, bigDepartureSecondsUnit;
@synthesize funnySaying, description, formattedTime, price;

- (void) setStopTime: (StopTime*) stopTime {
  _stopTime = stopTime;

  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"hh:mm a"];
  self.formattedTime.text = [dateFormatter stringFromDate:[[self stopTime] getStopDate]];
  self.price.text         = stopTime.price;

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

  self.bigDepartureHour.text    = [NSString stringWithFormat:@"%02d", [hour intValue]];
  self.bigDepartureMinute.text  = [NSString stringWithFormat:@"%02d", [minute intValue]];
  self.bigDepartureSeconds.text = [NSString stringWithFormat:@"%02d", [seconds intValue]];

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

- (void) addShadow:(UILabel*) thisLabel {
  thisLabel.shadowColor  = [UIColor blackColor];
  thisLabel.shadowOffset = CGSizeMake(0.0, 2.0);
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    UIView *contentView = self.contentView;

    UIImage *img = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"bg_timer" ofType:@"png"]];

    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [imgView setUserInteractionEnabled:NO];
    self.backgroundView = imgView;

    self.bigDepartureHour    = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:70.0 bold:YES];
    self.bigDepartureMinute  = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:70.0 bold:YES];
    self.bigDepartureSeconds = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:70.0 bold:YES];
    self.bigDepartureHourUnit    = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:30.0 bold:YES];
    self.bigDepartureMinuteUnit  = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:30.0 bold:YES];
    self.bigDepartureSecondsUnit = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:30.0 bold:YES];

    [self addShadow:self.bigDepartureHour];
    [self addShadow:self.bigDepartureMinute];
    [self addShadow:self.bigDepartureSeconds];
    [self addShadow:self.bigDepartureHourUnit];
    [self addShadow:self.bigDepartureMinuteUnit];
    [self addShadow:self.bigDepartureSecondsUnit];

    self.funnySaying = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:14.0 bold:YES];
    self.description = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:YES];
    self.formattedTime = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:NO];
    self.price = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:NO];

    [contentView addSubview:self.bigDepartureHour];
    [contentView addSubview:self.bigDepartureMinute];
    [contentView addSubview:self.bigDepartureSeconds];

    [contentView addSubview:bigDepartureHourUnit];
    [contentView addSubview:bigDepartureMinuteUnit];
    [contentView addSubview:bigDepartureSecondsUnit];

    [contentView addSubview:self.funnySaying];
    [contentView addSubview:self.description];
    [contentView addSubview:self.formattedTime];
    [contentView addSubview:self.price];

    [self.bigDepartureHour release];
    [self.bigDepartureMinute release];
    [self.bigDepartureSeconds release];
    [self.funnySaying release];
    [self.description release];
    [self.formattedTime release];
    [self.price release];

    [self setTimerColor:[UIColor whiteColor]];

    self.bigDepartureHour.text    = @"00";
    self.bigDepartureMinute.text  = @"00";
    self.bigDepartureSeconds.text = @"00";

    self.bigDepartureHourUnit.text    = @"h";
    self.bigDepartureMinuteUnit.text  = @"m";
    self.bigDepartureSecondsUnit.text = @"s";

  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void) setData:(NSDictionary *)dict {
  self.bigDepartureHour.text = [dict objectForKey:@"title"];
}

- (void) setTimerColor:(UIColor*) thisColor {
  [self.bigDepartureHour setTextColor:thisColor];
  [self.bigDepartureHourUnit setTextColor:thisColor];
  [self.bigDepartureMinute setTextColor:thisColor];
  [self.bigDepartureMinuteUnit setTextColor:thisColor];
  [self.bigDepartureSeconds setTextColor:thisColor];
  [self.bigDepartureSecondsUnit setTextColor:thisColor];

  [self.bigDepartureHour setHighlightedTextColor:thisColor];
  [self.bigDepartureHourUnit setHighlightedTextColor:thisColor];
  [self.bigDepartureMinute setHighlightedTextColor:thisColor];
  [self.bigDepartureMinuteUnit setHighlightedTextColor:thisColor];
  [self.bigDepartureSeconds setHighlightedTextColor:thisColor];
  [self.bigDepartureSecondsUnit setHighlightedTextColor:thisColor];
}

- (void) layoutTimer:(BOOL) showHours {
  CGRect contentRect = self.contentView.bounds;
  CGFloat boundsX    = contentRect.origin.x;

  if (showHours) {
    self.bigDepartureHour.frame        = CGRectMake(boundsX +  10,   0, 300, 100);
    self.bigDepartureHourUnit.frame    = CGRectMake(boundsX +  88,  14, 300, 100);
    self.bigDepartureMinute.frame      = CGRectMake(boundsX + 108,   0, 300, 100);
    self.bigDepartureMinuteUnit.frame  = CGRectMake(boundsX + 185,  14, 300, 100);
    self.bigDepartureSeconds.frame     = CGRectMake(boundsX + 214,   0, 300, 100);
    self.bigDepartureSecondsUnit.frame = CGRectMake(boundsX + 290,  14, 300, 100);
  } else {
    self.bigDepartureHour.frame        = CGRectMake(boundsX - 100,   0, 300, 100);
    self.bigDepartureHourUnit.frame    = CGRectMake(boundsX - 100,  14, 300, 100);
    self.bigDepartureMinute.frame      = CGRectMake(boundsX +  40,   0, 300, 100);
    self.bigDepartureMinuteUnit.frame  = CGRectMake(boundsX + 118,  14, 300, 100);
    self.bigDepartureSeconds.frame     = CGRectMake(boundsX + 154,   0, 300, 100);
    self.bigDepartureSecondsUnit.frame = CGRectMake(boundsX + 232,  14, 300, 100);
  }

}

- (void)layoutSubviews {

  [super layoutSubviews];

  // getting the cell size
  CGRect contentRect = self.contentView.bounds;

  // In this example we will never be editing, but this illustrates the appropriate pattern
  if (!self.editing) {
    [self layoutTimer:false];

    // get the X pixel spot
    CGFloat boundsX = contentRect.origin.x;
    self.funnySaying.frame   = CGRectMake(boundsX +  20,  98, 200,  20);
    self.description.frame   = CGRectMake(boundsX +  20, 115, 200,  20);
    self.formattedTime.frame = CGRectMake(boundsX + 250,  95,  80,  20);
    self.price.frame         = CGRectMake(boundsX + 250, 115,  80,  20);

  }
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
  /*
     Create and configure a label.
   */

  UIFont *font;
  if (bold) {
    font = [UIFont boldSystemFontOfSize:fontSize];
  } else {
    font = [UIFont systemFontOfSize:fontSize];
  }

  /*
         Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults.  To show selection properly, however, the views need to be transparent (so that the selection color shows through).  This is handled in setSelected:animated:.
   */
  UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  newLabel.backgroundColor = [UIColor clearColor];
  newLabel.opaque = YES;
  newLabel.textColor = primaryColor;
  newLabel.highlightedTextColor = selectedColor;
  newLabel.font = font;

  return newLabel;
}

#pragma mark -
#pragma mark Cleanup Methods

- (void)dealloc {
  [bigDepartureHour dealloc];
  [bigDepartureMinute dealloc];
  [bigDepartureSeconds dealloc];
  [bigDepartureHourUnit dealloc];
  [bigDepartureMinuteUnit dealloc];
  [bigDepartureSecondsUnit dealloc];

  [funnySaying dealloc];
  [description dealloc];
  [formattedTime dealloc];
  [price dealloc];

  [_countDownTimer dealloc];
  [_countDownStartDate dealloc];
  [_stopTime dealloc];

  [super dealloc];
}

@end
