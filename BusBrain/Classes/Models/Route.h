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
  NSString *_number;
  NSString *_longName;
  NSString *_shortName;
  NSString *_desc;
  NSString *_type;
  NSString *_url;
  NSString *_iconPath;
}

@property (nonatomic, retain) NSString *number;
@property (nonatomic, retain) NSString *longName;
@property (nonatomic, retain) NSString *shortName;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *iconPath;

- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void) routesFromPlist:(void (^) (NSArray *records))block;
+ (void) routesFromPlist:(CLLocation *)location block:(void (^) (NSArray *records))block;
+ (void)routesWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters block:(void (^) (NSArray *records))block;
+ (void)routesWithNearbyStops:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^) (NSDictionary *data))block;
+ (void) getRoute:(NSString *)route_id block:(void (^)(NSArray *records))block;

@end
