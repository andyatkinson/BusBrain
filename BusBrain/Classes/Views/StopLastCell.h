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

@property (nonatomic, retain) OHAttributedLabel *routeNumber;
@property (nonatomic, retain) OHAttributedLabel *stopName;
@property (nonatomic, retain) OHAttributedLabel *routeName;
@property (nonatomic, retain) OHAttributedLabel *relativeTime;

// internal function to ease setting up label text
- (void) setStop:(Stop*) stop;

@end
