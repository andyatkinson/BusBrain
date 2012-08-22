//
//  TransitAPIClient.h
//  BusBrain
//
//  Copyright 2012, Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

extern NSString * const kTransitAPIClientID;
extern NSString * const kTransitAPIBaseURLString;

@interface TransitAPIClient : AFHTTPClient
+ (TransitAPIClient *)sharedClient;
@end
