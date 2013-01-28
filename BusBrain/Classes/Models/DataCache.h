//
//  DataCache.h
//  BusBrain
//
//  Created by John Doll on 1/4/13.
//
//

#import <Foundation/Foundation.h>

@protocol BusProgressDelegate;
@protocol BusMainDelegate;

@interface DataCache : NSObject

+ (void) loadCacheStops:(void (^)(NSArray *records))block;
+ (void) loadCacheRoutes:(void (^)(NSArray *records))block;
+ (BOOL) isCacheStail;
+ (void) downloadCacheProgress:(id <BusProgressDelegate>)progress main:(id <BusMainDelegate>)main;

@end

@protocol BusProgressDelegate
- (void) setProgress:(float) progress;
- (void) dismiss;
@end

@protocol BusMainDelegate
- (void) setRoutesDB:(NSArray*)routes;
- (void) setStopsDB:(NSArray*)stops;
- (void) setCacheLoaded:(BOOL)loaded;
- (void) hideHUD;
@end
