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
#import "Stop.h"

@interface StopSearchCell : BusTableCell {
  OHAttributedLabel *_routeNumber;
  OHAttributedLabel *_routeDirection;
  OHAttributedLabel *_stopName;
}

@property (nonatomic, strong) OHAttributedLabel *routeNumber;
@property (nonatomic, strong) OHAttributedLabel *routeDirection;
@property (nonatomic, strong) OHAttributedLabel *stopName;

// internal function to ease setting up label text
- (void) setStop:(Stop*) stop;

@end
