//
//  NSDate+Convenience.h
//  Skeleton
//
//  Created by Systango on 18/08/15.
//  Copyright © 2016 Systango. All rights reserved
//

#import <Foundation/Foundation.h>

@interface NSDate (Convenience)

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+ (NSString *)stringFromMilliSeconds:(NSString *)milliSeconds format:(NSString *)format;
+ (NSDate *)dateFromMilliseconds:(NSString *)milliseconds format:(NSString *)format;
- (NSString *)stringInISO8601Format;
+ (NSString *)stringFromMilliSecondsInISO8601Format:(NSString *)milliSeconds;

@end
