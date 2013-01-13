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

@synthesize stopName             = _stopName;

- (void) setStop:(Stop*) stop {
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
    
    [contentView addSubview:[self stopName]];
    
  }

  return self;
}

- (void)layoutSubviews {

  [super layoutSubviews];

  // getting the cell size
  CGRect contentRect = [[self contentView] bounds];

  // get the X pixel spot
  CGFloat boundsX = contentRect.origin.x;

  [[self stopName]       setFrame: CGRectMake(boundsX +  10, 5, 280, 50)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
}


@end
