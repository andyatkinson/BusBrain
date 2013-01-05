//
//  StopTimeCell.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusTableCell.h"
#import "OHAttributedLabel.h"
#import "StopTime.h"

@interface StopTimeCell : BusTableCell {
  OHAttributedLabel *_relativeTime;
  OHAttributedLabel *_scheduleTime;
  OHAttributedLabel *_price;
  UIImageView *_icon;
}

@property (nonatomic, strong) OHAttributedLabel *relativeTime;
@property (nonatomic, strong) OHAttributedLabel *scheduleTime;
@property (nonatomic, strong) OHAttributedLabel *price;
@property (nonatomic, strong) UIImageView *icon;

// internal function to ease setting up label text
- (void) setStopTime:(StopTime*) stopTime;

@end
