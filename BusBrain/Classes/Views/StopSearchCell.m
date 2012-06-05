//
//  StopTimeCell.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "StopSearchCell.h"
#import "Stop.h"
#import "StopTime.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "NSString+BeetleFight.h"

@implementation StopSearchCell

@synthesize routeNumber          = _routeNumber;
@synthesize routeDirection       = _routeDirection;
@synthesize stopName             = _stopName;

- (void) setStop:(Stop*) stop {
  [[self stopName] setText: [stop name]];
  [[self routeNumber] setText: [[stop route] shortName]];
  [[self routeDirection] setText: [stop desc]];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    UIView *contentView = [self contentView];

    UIImage *bgImg = [[UIImage imageNamed:@"bg_cell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self setBackgroundView: [[UIImageView alloc] initWithImage:bgImg]];

    [self setRouteNumber:    [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:18.0 bold:YES]];
    [self setRouteDirection: [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:10.0 bold:NO]];
    [self setStopName:       [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:17.0 bold:NO]];
    
    [[self routeNumber] setTextAlignment:UITextAlignmentCenter];

    [contentView addSubview:[self routeNumber]];
    [contentView addSubview:[self routeDirection]];
    [contentView addSubview:[self stopName]];

    [[self routeNumber] release];
    [[self routeDirection] release];
    [[self stopName] release];
    
  }

  return self;
}

- (void)layoutSubviews {

  [super layoutSubviews];

  // getting the cell size
  CGRect contentRect = [[self contentView] bounds];

  // get the X pixel spot
  CGFloat boundsX = contentRect.origin.x;

  [[self routeNumber]    setFrame: CGRectMake(boundsX +  20, 15, 30,  30)];
  [[self routeDirection] setFrame: CGRectMake(boundsX +  10, 32, 60,  20)];
  [[self stopName]       setFrame: CGRectMake(boundsX +  75, 20, 220, 50)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
}

- (void)dealloc {
  [_routeNumber dealloc];
  [_routeDirection dealloc];
  [_stopName dealloc];
  
  [super dealloc];
}

@end
