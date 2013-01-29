//
//  DataCache.m
//  BusBrain
//
//  Created by John Doll on 1/4/13.
//
//

#import "BusBrainAppDelegate.h"
#import "DataCache.h"
#import "Stop.h"
#import "NSDate+BusBrain.h"
#import "MainTableViewController.h"
#import "TransitAPIClient.h"
#import "AFJSONRequestOperation.h"

@implementation DataCache

+ (BOOL) isCacheStail{
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  
  int lastCacheStamp = [settings integerForKey:@"lastCacheStamp"];
  NSDate *lastCacheDate = [NSDate dateWithTimeIntervalSince1970:lastCacheStamp];
  NSDate *now = [NSDate timeRightNow];
  
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit
                                             fromDate:lastCacheDate
                                               toDate:now
                                              options:0];
  
  if(components.day > 0 || components.hour > 20){
    return true;
  } else {
    return false;
  }
  
}

+ (NSString *) cacheFile {
  NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
  NSString *filepath = [documentsDirectory stringByAppendingPathComponent:@"CacheDB.json"];
  
  if(! [[NSFileManager defaultManager] fileExistsAtPath:filepath]){
    filepath = [[NSBundle mainBundle] pathForResource:@"data_cache" ofType:@"json"];
  }
  return filepath;
}

+ (void) loadCacheRoutes:(void (^)(NSArray *records))block {
  NSString *filepath = [DataCache cacheFile];

#ifdef DEBUG_BB
  NSLog(@"Loading Routes From: %@", filepath);
#endif
  
  NSData* jsonData = [NSData dataWithContentsOfFile:filepath];
  NSMutableArray *routes = [NSMutableArray array];
  
  if(jsonData == nil){
    NSLog(@"No Data?");
  } else {
    NSError* error;
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:kNilOptions
                                                                     error:&error];
    
    NSArray* routeDictArray = [jsonDictionary objectForKey:@"routes"];
    for (NSDictionary *attributes in routeDictArray) {
      Route *route = [[Route alloc] initWithAttributes:attributes];
      [routes addObject:route];
    }
    
    
  }
  
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"short_name" ascending:YES];
  NSArray * sortedArray=[routes sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
  
  if (block) {
    block ([NSArray arrayWithArray:sortedArray]);
  }
}

+ (void) loadCacheStops:(void (^)(NSArray *records))block {
  NSString *filepath = [DataCache cacheFile];
  //NSLog(@"Loading Stops From: %@", filepath);
  
  NSData* jsonData = [NSData dataWithContentsOfFile:filepath];
  NSMutableArray *mutableRecords = [NSMutableArray array];
  
  if(jsonData == nil){
    NSLog(@"No Data?");
  } else {
    NSError* error;
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:kNilOptions
                                                                     error:&error];
    
    NSArray* stopDictArray = [jsonDictionary objectForKey:@"stops"];
    for (NSDictionary *attributes in stopDictArray) {
      Stop *stop = [[Stop alloc] initWithAttributes:attributes];
      [mutableRecords addObject:stop];
    }
  }
  
  
  if (block) {
    block ([NSArray arrayWithArray:mutableRecords]);
  }
}

+ (void) downloadCacheProgress:(id <BusProgressDelegate>)progress main:(id <BusMainDelegate>)main {
#ifdef DEBUG_BB
  NSLog(@"Cache Download Started");
#endif
  
  NSMutableURLRequest *afRequest = [[TransitAPIClient sharedClient]
                                    requestWithMethod:@"GET"
                                    path:@"/bus/v2/searches.json"
                                    parameters:nil];
  
  NSString *documentsDirectory = [NSHomeDirectory()
                                  stringByAppendingPathComponent:@"Documents"];
  NSString *downloadPath = [documentsDirectory
                            stringByAppendingPathComponent:@"CurrentDownload.json"];
  
  AFHTTPRequestOperation *operation = [[TransitAPIClient sharedClient] HTTPRequestOperationWithRequest:afRequest
                                                                                               success:^(AFHTTPRequestOperation *operation, id JSON) {

#ifdef DEBUG_BB
  NSLog(@"Cache Received results");
#endif
         NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
         [settings setInteger:[[NSDate timeRightNow] timeIntervalSince1970] forKey:@"lastCacheStamp"];
         
         [progress dismiss];
         
         NSError* error = nil;
         NSFileManager *fileMgr = [NSFileManager defaultManager];
         
         NSString *dbPath = [documentsDirectory
                             stringByAppendingPathComponent:@"CacheDB.json"];
         NSString *backupPath = [documentsDirectory
                                 stringByAppendingPathComponent:@"BackupDB.json"];
         
         
         //Backup last good cache
         if ([fileMgr removeItemAtPath:backupPath error:&error] != YES) {
           NSLog(@"Unable to delete file (%@): %@", backupPath, [error localizedDescription]);
         }
         if(![fileMgr copyItemAtPath:downloadPath
                              toPath:backupPath
                               error:&error]){
           NSLog(@"Failed to Copy %@ -> %@", downloadPath, backupPath);
           NSLog(@"Error description-%@ \n", [error localizedDescription]);
           NSLog(@"Error reason-%@", [error localizedFailureReason]);
         }
         
         //Remove cache file
         if ([fileMgr removeItemAtPath:dbPath error:&error] != YES) {
           NSLog(@"Unable to delete file (%@): %@", dbPath, [error localizedDescription]);
         }
         
         //Replace cache with what was downloaded
         if(![fileMgr copyItemAtPath:downloadPath
                              toPath:dbPath
                               error:&error]){
           NSLog(@"Failed to Copy %@ -> %@", downloadPath, dbPath);
           NSLog(@"Error description-%@ \n", [error localizedDescription]);
           NSLog(@"Error reason-%@", [error localizedFailureReason]);
         }
         
         //Load new cache into memory
         [DataCache loadCacheStops:^(NSArray *db) {
           
           if([db count] > 0 ){
             [main setStopsDB:db];
           } else {
             NSLog(@"Purge corrupt download");
             NSError* error = nil;
             
             //Restore the backup into place
             if ([fileMgr removeItemAtPath:dbPath error:&error] != YES) {
               NSLog(@"Unable to delete file (%@): %@",dbPath, [error localizedDescription]);
             }
             
             //Replace cache with what was downloaded
             if(![fileMgr copyItemAtPath:backupPath
                                  toPath:dbPath
                                   error:&error]){
               NSLog(@"Failed to Copy %@ -> %@", backupPath, dbPath);
               NSLog(@"Error description-%@ \n", [error localizedDescription]);
               NSLog(@"Error reason-%@", [error localizedFailureReason]);
             }
             
           }
           
         }];
                                                                                                 
         [DataCache loadCacheRoutes:^(NSArray *db) {
           if([db count] > 0 ){
             [main setRoutesDB:db];
             [main setCacheLoaded:true];
           } else {
             //Corruption was already dealt with when loading the stops
           }
           [main hideHUD];
           
         }];
         
       } 
       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Failed: %@",[error localizedDescription]);
         [progress dismiss];
       }];
  
  [operation setDownloadProgressBlock:^(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
    float progressValue = ((float)((int)totalBytesRead) / (float)((int)totalBytesExpectedToRead));
    [progress setProgress:progressValue];
  }];
  
  
  [operation setOutputStream: [NSOutputStream outputStreamToFileAtPath:downloadPath append:NO]];
  
  [[TransitAPIClient sharedClient] enqueueHTTPRequestOperation:operation];
  
}

@end
