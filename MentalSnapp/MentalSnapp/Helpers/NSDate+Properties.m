//
//  NSDate+Convenience.m
//  Skeleton
//
//  Created by Systango on 18/08/15.
//  Copyright © 2016 Systango. All rights reserved
//

#import "NSDate+Properties.h"

@implementation NSDate (Convenience)

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format {
    if (!format) {
        format = @"yyyy-MM-dd";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format {
    if (!format) {
        format = @"yyyy-MM-dd";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)stringFromMilliSeconds:(NSString *)milliSeconds format:(NSString *)format {
    if (!format) {
        format = @"yyyy-MM-dd";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[milliSeconds doubleValue]/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)dateFromMilliseconds:(NSString *)milliseconds format:(NSString *)format {
    if (!format) {
        format = @"yyyy-MM-dd";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:[NSDate stringFromMilliSeconds:milliseconds format:format]];
    return date;
}

- (NSString *)stringInISO8601Format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    return [dateFormatter stringFromDate:self];
}

+ (NSString *)stringFromMilliSecondsInISO8601Format:(NSString *)milliSeconds {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[milliSeconds doubleValue]/1000];
    return [date stringInISO8601Format];
}

@end
