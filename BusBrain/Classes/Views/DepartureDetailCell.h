//
//  DepartureDetailCell.h
//  BusBrain
//
//  Created by Andy Atkinson on 7/12/09.
//  Copyright 2009 Andy Atkinson http://webandy.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DepartureDetailCell : UITableViewCell {
  IBOutlet UIImageView *departureIcon;
  IBOutlet UILabel *departureTime;
  IBOutlet UILabel *departureCost;
  IBOutlet UILabel *timeRemaining;
  IBOutlet UILabel *type;
  IBOutlet UILabel *headsign;
}

@property (nonatomic, retain) IBOutlet UILabel *departureTime;
@property (nonatomic, retain) IBOutlet UILabel *departureCost;
@property (nonatomic, retain) IBOutlet UILabel *timeRemaining;
@property (nonatomic, retain) IBOutlet UILabel *type;
@property (nonatomic, retain) IBOutlet UIImageView *departureIcon;
@property (nonatomic, retain) IBOutlet UILabel *headsign;

@end
