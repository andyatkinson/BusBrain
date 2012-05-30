//
//  TimeEntry.h
//  BusBrain
//
//  Created by Andrew Atkinson on 2/5/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeEntry : NSObject {
  NSArray *headsign_keys;
  NSArray *headsigns;
  NSArray *stop_times;
  NSString *template;
}

@property (nonatomic, retain) NSArray *headsign_keys;
@property (nonatomic, retain) NSArray *headsigns;
@property (nonatomic, retain) NSArray *stop_times;
@property (nonatomic, retain) NSString *template;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
