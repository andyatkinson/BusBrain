//
//  StopTimeCell.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
#import "StopTime.h"
#import "Stop.h"
#import "BusTableCell.h"

@interface StopLastCell : BusTableCell {
  OHAttributedLabel *_routeNumber;
  OHAttributedLabel *_stopName;
  OHAttributedLabel *_routeName;
  OHAttributedLabel *_relativeTime;
  
}

@property (nonatomic, strong) OHAttributedLabel *routeNumber;
@property (nonatomic, strong) OHAttributedLabel *stopName;
@property (nonatomic, strong) OHAttributedLabel *routeName;
@property (nonatomic, strong) OHAttributedLabel *relativeTime;

// internal function to ease setting up label text
- (void) setStop:(Stop*) stop;

@end
