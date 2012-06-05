//
//  TimeEntry.h
//  BusBrain
//
//  Created by Andrew Atkinson on 2/5/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeEntry : NSObject {
  NSArray  *_headsignKeys;
  NSArray  *_headsigns;
  NSArray  *_stopTimes;
  NSString *_template;
}

@property (nonatomic, retain) NSArray *headsignKeys;
@property (nonatomic, retain) NSArray *headsigns;
@property (nonatomic, retain) NSArray *stopTimes;
@property (nonatomic, retain) NSString *template;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
