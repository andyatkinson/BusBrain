//
//  CustomCell.m
//  BusBrain
//
//  Created by Andy Atkinson on 6/30/09.
//  Copyright 2009 Andy Atkinson http://webandy.com. All rights reserved.
//
#import "CustomCell.h"

@implementation CustomCell

@synthesize titleLabel, distanceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    UIView *myContentView = self.contentView;
    self.titleLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor blackColor] fontSize:17.0 bold:YES];
    self.titleLabel.textAlignment = UITextAlignmentLeft;
    [myContentView addSubview:self.titleLabel];
    [self.titleLabel release];

    self.distanceLabel = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor grayColor] fontSize:12.0 bold:NO];
    self.distanceLabel.textAlignment = UITextAlignmentLeft;
    [myContentView addSubview:self.distanceLabel];
    [self.distanceLabel release];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect contentRect = self.contentView.bounds;
  if(!self.editing) {
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    frame = CGRectMake(boundsX + 15, 8, 280, 24);
    self.titleLabel.frame = frame;

    frame = CGRectMake(boundsX + 15, 26, 280, 24);
    self.distanceLabel.frame = frame;
  }
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold {
  UIFont *font;
  if (bold) {
    font = [UIFont boldSystemFontOfSize:fontSize];
  } else {
    font = [UIFont systemFontOfSize:fontSize];
  }
  UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  newLabel.backgroundColor = [UIColor clearColor];
  newLabel.opaque = YES;
  newLabel.textColor = primaryColor;
  newLabel.highlightedTextColor = selectedColor;
  newLabel.font = font;
  return newLabel;
}


- (void)dealloc {
  [super dealloc];
  [titleLabel dealloc];
  [distanceLabel dealloc];
}


@end
