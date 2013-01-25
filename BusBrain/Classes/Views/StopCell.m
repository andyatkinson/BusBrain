//
//  StopTimeCell.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "BusLooknFeel.h"
#import "StopCell.h"
#import "Stop.h"
#import "NSAttributedString+Attributes.h"

@implementation StopCell

@synthesize stopName     = _stopName;
@synthesize stopCity     = _stopCity;
@synthesize stopDistance = _stopDistance;

- (void) setStop:(Stop*) stop {
  
  
  
  if([[stop route] short_name] > 0){
    [[self stopName]     setFrame: CGRectMake(  5, 10, 220, 20)];
    [[self stopCity]     setFrame: CGRectMake(  5, 30, 280, 20)];
    [[self stopDistance] setFrame: CGRectMake(230, 20,  60, 20)];
    
    [[self stopCity]     setHidden:NO];
    [[self stopDistance] setHidden:NO];
    
    [[self stopCity] setText: [[stop stop_city] capitalizedString]];
    [[self stopDistance] setText: [NSString stringWithFormat:@"%.1f mi.", [[stop distanceFromLocation] doubleValue] ]];
  } else {
    [[self stopName] setFrame: CGRectMake(5, 20, 280, 20)];
    [[self stopCity] setHidden:YES];
    [[self stopDistance] setHidden:YES];
    
    [[self stopCity]     setText: @""];
    [[self stopDistance] setText: @""];
  }
  
  [[self stopName] setText: [stop stop_name]];
  
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    [self initSelectionStyle];
    
    UIView *contentView = [self contentView];

    UIImage *bgImg = [[UIImage imageNamed:@"bg_cell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self setBackgroundView: [[UIImageView alloc] initWithImage:bgImg]];

    
    [self setStopName      : [self newUILabelWithPrimaryColor:[BusLooknFeel getDetailColor]
                                              selectedColor:[BusLooknFeel getDetailColor] 
                                                       font:[BusLooknFeel getDetailFont]]];
    
    [self setStopCity      : [self newUILabelWithPrimaryColor:[BusLooknFeel getDetailSmallColor]
                                                selectedColor:[BusLooknFeel getDetailSmallColor]
                                                         font:[BusLooknFeel getDetailSmallFont]]];
    
    [self setStopDistance  : [self newUILabelWithPrimaryColor:[BusLooknFeel getDetailSmallColor]
                                                selectedColor:[BusLooknFeel getDetailSmallColor]
                                                         font:[BusLooknFeel getDetailFont]]];
    
    [contentView addSubview:[self stopName]];
    [contentView addSubview:[self stopCity]];
    [contentView addSubview:[self stopDistance]];
    
  }

  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}


@end
