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

@synthesize stopName = _stopName;
@synthesize stopCity = _stopCity;

- (void) setStop:(Stop*) stop {
  
  
  
  if([[stop route] short_name] > 0){
    [[self stopName] setFrame: CGRectMake(5, 10, 280, 20)];
    [[self stopCity] setFrame: CGRectMake(5, 30, 280, 20)];
    
    [[self stopCity] setHighlighted:NO];
    [[self stopCity] setText: [[stop stop_city] capitalizedString]];
  } else {
    [[self stopName] setFrame: CGRectMake(5, 20, 280, 20)];
    [[self stopCity] setHighlighted:YES];
    
    [[self stopCity] setText: @""];
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
    
    [contentView addSubview:[self stopName]];
    [contentView addSubview:[self stopCity]];
    
  }

  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}


@end
