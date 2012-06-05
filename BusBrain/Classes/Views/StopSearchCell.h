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

@property (nonatomic, retain) OHAttributedLabel *routeNumber;
@property (nonatomic, retain) OHAttributedLabel *routeDirection;
@property (nonatomic, retain) OHAttributedLabel *stopName;

// internal function to ease setting up label text
- (void) setStop:(Stop*) stop;

@end
