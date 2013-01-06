//
//  Trip.h
//  BusBrain
//
//  Created by John Doll on 1/6/13.
//
//

#import <Foundation/Foundation.h>

@interface Trip : NSObject {
  NSString *_trip_id;
  NSString *_trip_headsign;
  NSString *_date;
  NSString *_hour;
  NSString *_minute;
}

@property (nonatomic, strong) NSString *trip_id;
@property (nonatomic, strong) NSString *trip_headsign;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *minute;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
