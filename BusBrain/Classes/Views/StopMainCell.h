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

@interface StopMainCell : BusTableCell {
  
  /* ANDY: I suggest having a "route" property and a "stop" property. stop_time won't be do-able for 1.0.
   route can be initialized by the API call to have route.route_id and route.short_name set.
   a "headsign" property may be necessary as well */
  
  OHAttributedLabel *_routeNumber;
  OHAttributedLabel *_stopName;
  OHAttributedLabel *_relativeTime;

}

@property (nonatomic, retain) OHAttributedLabel *routeNumber;
@property (nonatomic, retain) OHAttributedLabel *routeDirection;
@property (nonatomic, retain) OHAttributedLabel *stopName;
@property (nonatomic, retain) OHAttributedLabel *relativeTime;

// internal function to ease setting up label text
- (void) setStop:(Stop*) stop;

@end
