//
//  BusTableCell.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
#import "StopTime.h"
#import "Stop.h"

@interface BusTableCell : UITableViewCell {
  BOOL _dataRefreshRequested;
}

@property (nonatomic) BOOL dataRefreshRequested;

- (OHAttributedLabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor 
                                  selectedColor:(UIColor *)selectedColor 
                                       fontSize:(CGFloat)fontSize 
                                           bold:(BOOL)bold;

- (OHAttributedLabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor 
                                  selectedColor:(UIColor *)selectedColor 
                                       font:(UIFont *) font;
@end