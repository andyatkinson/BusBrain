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

@interface StopLastCell : UITableViewCell {
  OHAttributedLabel *routeNumber;
  OHAttributedLabel *stopName;
  OHAttributedLabel *routeName;
  OHAttributedLabel *relativeTime;
  
  BOOL dataRefreshRequested;
}

@property (nonatomic, retain) OHAttributedLabel *routeNumber;
@property (nonatomic, retain) OHAttributedLabel *stopName;
@property (nonatomic, retain) OHAttributedLabel *routeName;
@property (nonatomic, retain) OHAttributedLabel *relativeTime;
@property (nonatomic) BOOL dataRefreshRequested;

// internal function to ease setting up label text
-(OHAttributedLabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;
- (void) setStop:(Stop*) stop;

@end
