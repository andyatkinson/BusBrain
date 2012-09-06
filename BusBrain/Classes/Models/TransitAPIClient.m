//
//  TransitAPIClient.m
//  BusBrain
//
//  Copyright 2012, Beetle Fight. All rights reserved.
//

#import "TransitAPIClient.h"
#import "AFJSONRequestOperation.h"

NSString * const kTransitAPIClientID = @"94adbe66804dbf92e7290de08334d5d0";
NSString * const kTransitAPIBaseURLString = @"http://api.beetlefight.com";
//NSString * const kTransitAPIBaseURLString = @"http://localhost:3000";
//NSString * const kTransitAPIBaseURLString = @"http://uranus.lan";

@implementation TransitAPIClient

+ (TransitAPIClient *)sharedClient {
  static TransitAPIClient *_sharedClient = nil;
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
                  _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kTransitAPIBaseURLString]];
                });

  return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (!self) {
    return nil;
  }

  [self registerHTTPOperationClass:[AFJSONRequestOperation class]];

  // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
  [self setDefaultHeader:@"Accept" value:@"application/json"];

  // X-Transit-API-Key HTTP Header
  [self setDefaultHeader:@"X-Transit-API-Key" value:kTransitAPIClientID];

  // X-UDID HTTP Header
  [self setDefaultHeader:@"X-UDID" value:[[UIDevice currentDevice] uniqueIdentifier]];

  return self;
}

@end

