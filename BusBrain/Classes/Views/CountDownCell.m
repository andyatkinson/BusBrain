//
//  CountDownCell.m
//  BusBrain
//
//  Created by John Doll on 1/13/13.
//
//

#import "CountDownCell.h"
#import "FunnyPhrase.h"

@implementation CountDownCell

@synthesize countDown = _countDown;

- (void) stopTimer {
  [[self countDown] stopTimer];
}
- (void) setStop:(Stop*) stop {
  [[[self countDown] funnySaying] setText: [FunnyPhrase rand]];
  [[[self countDown] description] setText: [[stop trip] trip_headsign] ];
}

- (void) setStopTime:(StopTime*) stop_time {
  [[self countDown] setStopTime:stop_time];
  [[self countDown] startTimer];
}

- (void) setNexTrip:(NSString*) tripText {
  [[[self countDown] nextTripTime] setText: tripText];
}

- (void) setFormatedTime:(NSString*) timeString {
  [[[self countDown] formattedTime] setText: timeString];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    [self initSelectionStyle];
    
    UIView *contentView = [self contentView];
    
    UIImage *bgImg = [[UIImage imageNamed:@"bg_cell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self setBackgroundView: [[UIImageView alloc] initWithImage:bgImg]];
    
    
    [self setCountDown:[[CountDownView alloc] init]];
    
    [contentView addSubview:[self countDown]];
    
  }
  
  return self;
}

- (void)layoutSubviews {
  
  [super layoutSubviews];
  
  CGRect contentRect = [[self contentView] bounds];
  [[self countDown]       setFrame: contentRect];
}

@end
