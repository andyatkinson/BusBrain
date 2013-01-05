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

@property (nonatomic, strong) NSString *route_id;
@property (nonatomic, strong) NSString *long_name;
@property (nonatomic, strong) NSString *short_name;
@property (nonatomic, strong) NSString *route_desc;
@property (nonatomic, strong) NSString *route_type;
@property (nonatomic, strong) NSString *route_url;
@property (nonatomic, strong) NSString *icon_path;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void) routesFromFile:(void (^) (NSArray *records))block;
+ (void) routesFromFile:(CLLocation *)location block:(void (^) (NSArray *records))block;

@end
