//
//  Info.h
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Info : NSObject {
  NSString *detail;
}

@property (nonatomic, retain) NSString *detail;

- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)infoDetailURLEndpoint:(NSString *)urlString parameters:(NSDictionary *)parameters block:(void (^) (NSArray *records))block;

@end
