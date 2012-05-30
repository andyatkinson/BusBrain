//
//  DepartureDetailCell.m
//  BusBrain
//
//  Created by Andy Atkinson on 7/12/09.
//  Copyright 2009 Andy Atkinson http://webandy.com. All rights reserved.
//

#import "DepartureDetailCell.h"


@implementation DepartureDetailCell

@synthesize departureTime, departureCost, timeRemaining, type, departureIcon, headsign;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    // Initialization code
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)dealloc {
  [super dealloc];
}


@end
