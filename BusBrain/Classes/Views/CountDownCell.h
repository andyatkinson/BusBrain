//
//  CountDownCell.h
//  BusBrain
//
//  Created by John Doll on 1/13/13.
//
//

#import "BusTableCell.h"
#import "CountDownView.h"

@interface CountDownCell : BusTableCell {
  CountDownView *_countDown;
}

@property (nonatomic, strong) CountDownView *countDown;

- (void) setStop:(Stop*) stop;
- (void) setStopTime:(StopTime*) stop_time;
- (void) setNexTrip:(NSString*) tripText;
- (void) setFormatedTime:(NSString*) timeString;
- (void) stopTimer;

@end
