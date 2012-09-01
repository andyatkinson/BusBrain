//
//  Route.h
//  BusBrain
//
//  Created by Andrew Atkinson on 12/2/11.
//  Copyright 2011 Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Route : NSObject {
  NSString *_route_id;
  NSString *_long_name;
  NSString *_short_name;
  NSString *_route_desc;
  NSString *_route_type;
  NSString *_route_url;
  NSString *_icon_path;
}

@property (nonatomic, retain) NSString *route_id;
@property (nonatomic, retain) NSString *long_name;
@property (nonatomic, retain) NSString *short_name;
@property (nonatomic, retain) NSString *route_desc;
@property (nonatomic, retain) NSString *route_type;
@property (nonatomic, retain) NSString *route_url;
@property (nonatomic, retain) NSString *icon_path;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void) routesFromPlist:(void (^) (NSArray *records))block;
+ (void) routesFromPlist:(CLLocation *)location block:(void (^) (NSArray *records))block;

@end
