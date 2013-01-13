//
//  TripCell.m
//  BusBrain
//
//  Created by John Doll on 1/13/13.
//
//

#import "TripCell.h"
#import "BusLooknFeel.h"
#import "NSAttributedString+Attributes.h"

@implementation TripCell

@synthesize tripName      = _tripName;
@synthesize tripDirection = _tripDirection;

- (void) setTrip:(Trip*) trip {
  [[self tripDirection] setText: [trip getDirection]];
  [[self tripName] setText: [trip trip_headsign]];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    [self initSelectionStyle];
    
    UIView *contentView = [self contentView];
    
    UIImage *bgImg = [[UIImage imageNamed:@"bg_cell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self setBackgroundView: [[UIImageView alloc] initWithImage:bgImg]];
    
    
    [self setTripDirection   : [self newUILabelWithPrimaryColor:[BusLooknFeel getRouteDirectionColor]
                                              selectedColor:[BusLooknFeel getRouteDirectionColor]
                                                       font:[BusLooknFeel getRouteDirectionFont]]];
    
    [self setTripName        : [self newUILabelWithPrimaryColor:[BusLooknFeel getRouteTitleColor]
                                              selectedColor:[BusLooknFeel getRouteTitleColor]
                                                       font:[BusLooknFeel getRouteTitleFont]]];
    
    [[self tripName] setNumberOfLines:2];
    [[self tripName] setLineBreakMode:UILineBreakModeWordWrap];
    
    [contentView addSubview:[self tripDirection]];
    [contentView addSubview:[self tripName]];
    
  }
  
  return self;
}

- (void)layoutSubviews {
  
  [super layoutSubviews];
  
  // getting the cell size
  CGRect contentRect = [[self contentView] bounds];
  
  CGFloat boundsX = contentRect.origin.x;
  
  [[self tripDirection]  setFrame: CGRectMake(boundsX +  10, 15, 50, 30)];
  [[self tripName]       setFrame: CGRectMake(boundsX +  50, 0, 240, 60)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}


@end