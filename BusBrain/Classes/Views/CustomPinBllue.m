//
//  CustomPin.m
//  BusBrain
//
//  Created by Andrew Atkinson on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomPinBlue.h"


@implementation CustomPinBlue

- (id)initWithAnnotation:(id <MKAnnotation>)annotation
{
  self = [super initWithAnnotation:annotation reuseIdentifier:@"CustomPinBlueId"];

  if (self)
  {
    UIImage *theImage = [UIImage imageNamed:@"nstr_map_pin.png"];

    if (!theImage)
      return nil;

    self.image = theImage;
  }
  return self;
}
@end

