//
//  CustomPinBlack.h
//  BusBrain
//
//  Created by Andrew Atkinson on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@interface CustomPinBlack : MKAnnotationView
{
}
- (id)initWithAnnotation:(id <MKAnnotation>)annotation;
@end