//
//  Headsign.h
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Headsign : NSObject {
  NSString *_headsign_key;
  NSString *_headsign_name;
}

@property (nonatomic, retain) NSString *headsign_key;
@property (nonatomic, retain) NSString *headsign_name;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
