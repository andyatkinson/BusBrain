//
//  StopTimeCell.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "BusLooknFeel.h"
#import "StopLastCell.h"
#import "Stop.h"
#import "StopTime.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "NSString+BeetleFight.h"

@implementation StopLastCell

@synthesize routeNumber          = _routeNumber;
@synthesize routeName            = _routeName;
@synthesize relativeTime         = _relativeTime;
@synthesize stopName             = _stopName;

- (void) setStop:(Stop*) stop {
  
  StopTime *nextStopTime = [stop nextStopTime];

  NSString *relativeString;
  if (nextStopTime != nil) {
    NSArray  *departureData = [[stop nextStopTime] getTimeTillDeparture];
    NSNumber *days    = (NSNumber*) [departureData objectAtIndex:1];
    NSNumber *hour    = (NSNumber*) [departureData objectAtIndex:2];
    NSNumber *minute  = (NSNumber*) [departureData objectAtIndex:3];
    NSNumber *seconds = (NSNumber*) [departureData objectAtIndex:4];

    if([days intValue] > 0){
      relativeString = [NSString stringWithFormat:@"%dd", [hour intValue]];
    } else if([hour intValue] > 0){
      relativeString = [NSString stringWithFormat:@"%dh", [hour intValue]];
    } else if ( [minute intValue] > 0 ) {
      relativeString = [NSString stringWithFormat:@"%dm", [minute intValue]];
    } else if ( [seconds intValue] > 0 ) {
      relativeString = [NSString stringWithFormat:@"%ds", [seconds intValue]];
    } else {
      [self setDataRefreshRequested:true];
      relativeString = @"0s";
    }
  } else {
    relativeString = @"";
    [self setDataRefreshRequested:false];
  }

  NSMutableAttributedString * string = [[NSMutableAttributedString alloc]
                                        initWithString:relativeString];

  [string setTextColor:[[self relativeTime] textColor]];
  [string setFont:[[self relativeTime] font]];
  [string setTextAlignment:kCTRightTextAlignment lineBreakMode:0];

  [string setFont:[BusLooknFeel getDetailSmallFont] range:[relativeString rangeOfString:@"d"]];
  [string setFont:[BusLooknFeel getDetailSmallFont] range:[relativeString rangeOfString:@"h"]];
  [string setFont:[BusLooknFeel getDetailSmallFont] range:[relativeString rangeOfString:@"m"]];
  [string setFont:[BusLooknFeel getDetailSmallFont] range:[relativeString rangeOfString:@"s"]];

  [[self relativeTime] setAttributedText: string];
  [[self stopName] setText: [stop stop_name]];
  
  [[self routeNumber] setText: [[stop route] short_name]];
  [[self routeName] setText: [[stop headsign] headsign_name]];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    [self initSelectionStyle];
    
    UIView *contentView = [self contentView];

    UIImage *bgImg = [[UIImage imageNamed:@"bg_cell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self setBackgroundView: [[UIImageView alloc] initWithImage:bgImg]];


    [self setRouteNumber   : [self newLabelWithPrimaryColor:[BusLooknFeel getDetailColor] 
                                              selectedColor:[BusLooknFeel getDetailColor] 
                                                       font:[BusLooknFeel getDetailFont]]];
    
    [self setRelativeTime  : [self newLabelWithPrimaryColor:[BusLooknFeel getDetailColor] 
                                              selectedColor:[BusLooknFeel getDetailColor] 
                                                       font:[BusLooknFeel getDetailFont]]];
    
    [self setStopName      : [self newLabelWithPrimaryColor:[BusLooknFeel getTitleColor] 
                                              selectedColor:[BusLooknFeel getTitleColor] 
                                                       font:[BusLooknFeel getTitleFont]]];
    
    [self setRouteName     : [self newLabelWithPrimaryColor:[BusLooknFeel getSubTitleColor] 
                                              selectedColor:[BusLooknFeel getSubTitleColor] 
                                                       font:[BusLooknFeel getSubTitleFont]]];

    
    [[self routeNumber] setTextAlignment:UITextAlignmentCenter];

    [contentView addSubview:[self relativeTime]];
    [contentView addSubview:[self routeNumber]];
    [contentView addSubview:[self routeName]];
    [contentView addSubview:[self stopName]];

    [self routeNumber];
    [self routeName];
    [self relativeTime];
    [self stopName];
    
  }

  return self;
}

- (void)layoutSubviews {

  [super layoutSubviews];

  // getting the cell size
  CGRect contentRect = [[self contentView] bounds];

  // get the X pixel spot
  CGFloat boundsX = contentRect.origin.x;

  [[self routeNumber]  setFrame: CGRectMake(boundsX +  23, 15, 30,  30)];
  [[self stopName]     setFrame: CGRectMake(boundsX +  75, 10, 180, 30)];
  [[self routeName]    setFrame: CGRectMake(boundsX +  75, 30, 180, 30)];
  [[self relativeTime] setFrame: CGRectMake(boundsX + 255, 17, 35,  30)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}


@end
