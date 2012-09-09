//
//  NoStops.m
//  BusBrain
//
//  Created by John Doll on 9/8/12.
//  Copyright (c) 2012 LivingSocial. All rights reserved.
//

#import "NoStops.h"

#import "BusLooknFeel.h"
#import "NoStops.h"
#import "Stop.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "NSString+BeetleFight.h"

@implementation NoStops

@synthesize message          = _message;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    [self initSelectionStyle];
    
    UIView *contentView = [self contentView];
    
    UIImage *bgImg = [[UIImage imageNamed:@"bg_cell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self setBackgroundView: [[UIImageView alloc] initWithImage:bgImg]];
    
    
    [self setMessage       : [self newLabelWithPrimaryColor:[BusLooknFeel getDetailColor]
                                              selectedColor:[BusLooknFeel getDetailColor]
                                                       font:[BusLooknFeel getDetailFont]]];
    
    
    [contentView addSubview:[self message]];
    
    [[self message] release];
    
  }
  
  return self;
}

- (void)layoutSubviews {
  
  [super layoutSubviews];
  
  CGRect contentRect = [[self contentView] bounds];
  CGFloat boundsX = contentRect.origin.x;
  
  [[self message]  setFrame: CGRectMake(boundsX +  10, 15, 200,  30)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)dealloc {
  [_message dealloc];

  [super dealloc];
}

@end
