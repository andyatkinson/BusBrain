//
//  RouteCell.m
//  BusBrain
//
//  Created by John Doll on 1/13/13.
//
//

#import "RouteCell.h"
#import "BusLooknFeel.h"
#import "NSAttributedString+Attributes.h"

@implementation RouteCell

@synthesize routeName   = _routeName;
@synthesize routeNumber = _routeNumber;

- (void) setRoute:(Route*) route {
  [[self routeNumber] setText: [NSString stringWithFormat:@"%i", [route short_name]]];
  [[self routeName] setText: [route long_name]];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    [self initSelectionStyle];
    
    UIView *contentView = [self contentView];
    
    UIImage *bgImg = [[UIImage imageNamed:@"bg_cell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self setBackgroundView: [[UIImageView alloc] initWithImage:bgImg]];
    
    
    [self setRouteNumber   : [self newUILabelWithPrimaryColor:[BusLooknFeel getRouteDirectionColor]
                                              selectedColor:[BusLooknFeel getRouteDirectionColor]
                                                       font:[BusLooknFeel getRouteDirectionFont]]];
    
    [self setRouteName     : [self newUILabelWithPrimaryColor:[BusLooknFeel getRouteTitleColor]
                                              selectedColor:[BusLooknFeel getRouteTitleColor]
                                                       font:[BusLooknFeel getRouteTitleFont]]];
    
    [[self routeName] setNumberOfLines:2];
    [[self routeName] setLineBreakMode:UILineBreakModeWordWrap];
    
    [contentView addSubview:[self routeNumber]];
    [contentView addSubview:[self routeName]];
    
  }
  
  return self;
}

- (void)layoutSubviews {
  
  [super layoutSubviews];
  
  [[self routeNumber]     setFrame: CGRectMake(10, 15, 50, 30)];
  [[self routeName]       setFrame: CGRectMake(70, 0, 220, 60)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}


@end
