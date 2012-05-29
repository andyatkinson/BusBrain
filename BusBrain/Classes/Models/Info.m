//
//  Info.m
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "Info.h"
#import "TransitAPIClient.h"

@implementation Info

@synthesize detail;

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super init];
  if (!self) {
    return nil;
  }

  self.detail = [attributes valueForKeyPath:@"detail"];

  return self;
}

+ (void)infoDetailURLEndpoint:(NSString *)urlString parameters:(NSDictionary *)parameters block:(void (^)(NSArray *records))block {
  NSDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];

  [[TransitAPIClient sharedClient] getPath:urlString parameters:mutableParameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
     NSMutableArray *mutableRecords = [NSMutableArray array];

     NSDictionary *attributes = [JSON valueForKeyPath:@"info"];

     Info *info = [[[Info alloc] initWithAttributes:attributes] autorelease];
     [mutableRecords addObject:info];

     if (block) {
       block ([NSArray arrayWithArray:mutableRecords]);
     }
   } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
     if (block) {
       block ([NSArray array]);
     }
   }];
}

@end
