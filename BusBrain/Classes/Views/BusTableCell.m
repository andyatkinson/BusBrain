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

- (void) addShadow:(OHAttributedLabel*) thisLabel {
  [thisLabel setShadowColor: [UIColor blackColor]];
  [thisLabel setShadowOffset: CGSizeMake(0.0, 2.0)];
}

- (OHAttributedLabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor 
                                  selectedColor:(UIColor *)selectedColor 
                                       fontSize:(CGFloat)fontSize 
                                           bold:(BOOL)bold {
  /*
   Create and configure a label.
   */
  
  UIFont *font;
  if (bold) {
    font = [UIFont boldSystemFontOfSize:fontSize];
  } else {
    font = [UIFont systemFontOfSize:fontSize];
  }
  
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

- (void)dealloc {
  [super dealloc];
}

@end
