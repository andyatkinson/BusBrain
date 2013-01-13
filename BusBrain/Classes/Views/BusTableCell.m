//
//  BusTableCell.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "BusTableCell.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "NSString+BeetleFight.h"

@implementation BusTableCell

@synthesize dataRefreshRequested = _dataRefreshRequested;


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void) initSelectionStyle {
  UIView *selectHighlightView = [[UIView alloc] init];
  [selectHighlightView setBackgroundColor:[UIColor blackColor]];
  [self setSelectedBackgroundView: selectHighlightView];
}

- (OHAttributedLabel *)newOHALabelWithPrimaryColor:(UIColor *) primaryColor
                                  selectedColor:(UIColor *) selectedColor 
                                       fontSize:(CGFloat) fontSize 
                                           bold:(BOOL) bold {

  UIFont *font;
  if (bold) {
    font = [UIFont boldSystemFontOfSize:fontSize];
  } else {
    font = [UIFont systemFontOfSize:fontSize];
  }

  OHAttributedLabel *newLabel = [self newOHALabelWithPrimaryColor:primaryColor selectedColor:selectedColor font: font];
  return newLabel;
}

- (OHAttributedLabel *)newOHALabelWithPrimaryColor:(UIColor *)primaryColor
                                  selectedColor:(UIColor *)selectedColor 
                                           font:(UIFont *) font {
  
  /*
   Views are drawn most efficiently when they are opaque and do not have a clear background, 
   so set these defaults.  To show selection properly, however, the views need to be transparent 
   (so that the selection color shows through).  This is handled in setSelected:animated:.
   */
  OHAttributedLabel *newLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
  [newLabel setBackgroundColor: [UIColor clearColor]];
  [newLabel setOpaque: YES];
  [newLabel setTextColor: primaryColor];
  [newLabel setHighlightedTextColor: selectedColor];
  [newLabel setFont: font];
  
  return newLabel;
}

- (UILabel *)newUILabelWithPrimaryColor:(UIColor *) primaryColor
                                     selectedColor:(UIColor *) selectedColor
                                          fontSize:(CGFloat) fontSize
                                              bold:(BOOL) bold {
  
  UIFont *font;
  if (bold) {
    font = [UIFont boldSystemFontOfSize:fontSize];
  } else {
    font = [UIFont systemFontOfSize:fontSize];
  }
  
  UILabel *newLabel = [self newUILabelWithPrimaryColor:primaryColor selectedColor:selectedColor font: font];
  return newLabel;
}

- (UILabel *)newUILabelWithPrimaryColor:(UIColor *)primaryColor
                                     selectedColor:(UIColor *)selectedColor
                                              font:(UIFont *) font {

  UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  [newLabel setBackgroundColor: [UIColor clearColor]];
  [newLabel setOpaque: YES];
  [newLabel setTextColor: primaryColor];
  [newLabel setHighlightedTextColor: selectedColor];
  [newLabel setFont: font];
  
  return newLabel;
}



@end
