//
//  TripCell.h
//  BusBrain
//
//  Created by John Doll on 1/13/13.
//
//

#import "BusTableCell.h"
#import "Trip.h"

@interface TripCell : BusTableCell {
  UILabel *_tripName;
  UILabel *_tripDirection;
}

@property (nonatomic, strong) UILabel *tripName;
@property (nonatomic, strong) UILabel *tripDirection;

- (void) setTrip:(Trip*) trip;

@end
