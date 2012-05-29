//
//  StopTimeCell.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
#import "StopTime.h"

@interface StopTimeCell : UITableViewCell {
  OHAttributedLabel *relativeTime;
  OHAttributedLabel *scheduleTime;
  OHAttributedLabel *price;
  UIImageView *icon;
}

@property (nonatomic, retain) OHAttributedLabel *relativeTime;
@property (nonatomic, retain) OHAttributedLabel *scheduleTime;
@property (nonatomic, retain) OHAttributedLabel *price;
@property (nonatomic, retain) UIImageView *icon;

// internal function to ease setting up label text
-(OHAttributedLabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;
- (void) setStopTime:(StopTime*) stopTime;

@end
