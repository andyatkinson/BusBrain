//
//  Headsign.h
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Headsign : NSObject {
  NSString *_headsignKey;
  NSString *_headsignPublicName;
}

@property (nonatomic, retain) NSString *headsignKey;
@property (nonatomic, retain) NSString *headsignPublicName;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
