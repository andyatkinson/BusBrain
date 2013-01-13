//
//  StopTimeCell.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusTableCell.h"
#import "StopTime.h"
#import "Stop.h"

@interface StopCell : BusTableCell {
  UILabel *_stopName;
}

@property (nonatomic, strong) UILabel *stopName;

- (void) setStop:(Stop*) stop;

@end
