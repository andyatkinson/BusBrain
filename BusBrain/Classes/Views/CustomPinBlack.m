//
//  CustomPinBlack.m
//  BusBrain
//
//  Created by Andrew Atkinson on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomPinBlack.h"


@implementation CustomPinBlack

- (id)initWithAnnotation:(id <MKAnnotation>)annotation
{
  self = [super initWithAnnotation:annotation reuseIdentifier:@"CustomPinBlackId"];

  if (self)
  {
    UIImage *theImage = [UIImage imageNamed:@"hiaw_map_pin.png"];

    if (!theImage)
      return nil;

    self.image = theImage;
  }
  return self;
}
@end
