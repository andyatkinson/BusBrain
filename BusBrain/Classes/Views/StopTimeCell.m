//
//  StopTimeCell.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "BusLooknFeel.h"
#import "StopTimeCell.h"
#import "StopTime.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "NSString+BeetleFight.h"

@implementation StopTimeCell

@synthesize relativeTime = _relativeTime;
@synthesize scheduleTime = _scheduleTime;
@synthesize price        = _price;
@synthesize icon         = _icon;

- (void) setStopTime:(StopTime*) stopTime {
  NSArray  *departureData = [stopTime getTimeTillDeparture];
  NSNumber *hour    = (NSNumber*) [departureData objectAtIndex:1];
  NSNumber *minute  = (NSNumber*) [departureData objectAtIndex:2];
  NSString *relativeString = [NSString stringWithFormat:@"%dh %02dm", [hour intValue], [minute intValue]];

  NSMutableAttributedString * string = [[NSMutableAttributedString alloc]
                                        initWithString:relativeString];

  [string setTextColor:[[self relativeTime] textColor]];
  [string setFont: [[self relativeTime] font]];

  [string setFont:[BusLooknFeel getUpcomingTitleSmallFont] range:[relativeString rangeOfString:@"h"]];
  [string setFont:[BusLooknFeel getUpcomingTitleSmallFont] range:[relativeString rangeOfString:@"m"]];

  [[self relativeTime] setAttributedText: string];
  [[self scheduleTime] setText: [[stopTime departureTime] hourMinuteFormatted]];
  [[self price] setText: @""];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    [self initSelectionStyle];
    
    UIView *contentView = [self contentView];

    UIImage *bgImg = [[UIImage imageNamed:@"bg_cell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self setBackgroundView: [[UIImageView alloc] initWithImage:bgImg]];

    [self setIcon : [[ UIImageView alloc ] init]];
    
    [self setRelativeTime  : [self newLabelWithPrimaryColor:[BusLooknFeel getUpcomingTitleColor] 
                                              selectedColor:[BusLooknFeel getUpcomingTitleColor] 
                                                       font:[BusLooknFeel getUpcomingTitleBigFont]]];
    
    [self setScheduleTime  : [self newLabelWithPrimaryColor:[BusLooknFeel getUpcomingSubTitleColor] 
                                              selectedColor:[BusLooknFeel getUpcomingSubTitleColor] 
                                                       font:[BusLooknFeel getUpcomingSubTitleFont]]];
    [self setPrice         : [self newLabelWithPrimaryColor:[BusLooknFeel getUpcomingSubTitleColor] 
                                              selectedColor:[BusLooknFeel getUpcomingSubTitleColor] 
                                                       font:[BusLooknFeel getUpcomingSubTitleFont]]];

    [[self scheduleTime] setTextAlignment:UITextAlignmentRight];
    
    [contentView addSubview:[self icon]];
    [contentView addSubview:[self relativeTime]];
    [contentView addSubview:[self scheduleTime]];
    [contentView addSubview:[self price]];

    [[self icon] release];
    [[self relativeTime] release];
    [[self scheduleTime] release];
    [[self price] release];
  }

  return self;
}

- (void)layoutSubviews {

  [super layoutSubviews];

  // getting the cell size
  CGRect contentRect = [[self contentView] bounds];

  // get the X pixel spot
  CGFloat boundsX = contentRect.origin.x;

  /*
        Place the label.
        place the label whatever the current X is plus 10 pixels from the left
        place the label 4 pixels from the top
        make the label 200 pixels wide
        make the label 20 pixels high
  */
  [[self icon]         setFrame: CGRectMake(boundsX +  10, 18, 20,  20)];
  [[self relativeTime] setFrame: CGRectMake(boundsX +  40, 10, 200, 50)];
  
  [[self price]        setFrame: CGRectMake(boundsX + 160, 23, 80,  50)];
  [[self scheduleTime] setFrame: CGRectMake(boundsX + 230, 23, 75,  50)];
  

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)dealloc {
  [_relativeTime dealloc];
  [_scheduleTime dealloc];
  [_icon dealloc];
  [_price dealloc];
  
  [super dealloc];
}

@end
