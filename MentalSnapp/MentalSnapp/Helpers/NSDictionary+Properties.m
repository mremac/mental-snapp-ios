//
//  NSDictionary+hasValueForKey.m
//  Skeleton
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "NSDictionary+Properties.h"

@implementation NSDictionary_hasValueForKey


@end

@implementation NSDictionary (HasValueForKey)

- (BOOL)hasValueForKey:(NSString *)key
{
    if([self valueForKey:key] && [self valueForKey:key] != [NSNull alloc])
        return YES;
    else
        return NO;
}


@end
