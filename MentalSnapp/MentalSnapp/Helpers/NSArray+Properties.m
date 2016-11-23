//
//  NSArray+MoreFunctionality.m
//  Skeleton
//
//  Created by Systango on 19/08/15.
//  Copyright © 2016 Systango. All rights reserved
//

#import "NSArray+Properties.h"

@implementation NSArray (MoreFunctionality)

- (NSArray *)sortArrayWithKey:(NSString *)key ascending:(BOOL)ascending {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    return [self sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

@end
