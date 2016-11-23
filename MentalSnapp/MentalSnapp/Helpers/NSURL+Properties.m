//
//  NSURL+EncodedURL.m
//  Skeleton
//
//  Created by Systango on 03/11/14.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "NSURL+Properties.h"

@implementation NSURL (EncodedURL)

+ (id)URLWithEncodedString:(NSString *)URLString
{
    //TODO: not tested
    NSString *encodedURL = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet whitespaceCharacterSet]];
    return [NSURL URLWithString:encodedURL];
}

@end
