//
//  TransitAPIClient.h
//  TrainBrain
//
//  Created by Andrew Atkinson on 2/5/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

extern NSString * const kTransitAPIClientID;
extern NSString * const kTransitAPIBaseURLString;

@interface TransitAPIClient : AFHTTPClient
+ (TransitAPIClient *)sharedClient;
@end
