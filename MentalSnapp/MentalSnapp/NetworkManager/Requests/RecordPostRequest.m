//
//  RecordPostRequest.m
//  MentalSnapp
//
//  Created by Systango on 12/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "RecordPostRequest.h"

@interface RecordPostRequest ()

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation RecordPostRequest

- (id)initForPostRecordPost:(RecordPost *)post {
    self = [super init];
    if (self) {
        NSMutableDictionary *dictionary = [[post toDictionary] mutableCopy];
        _parameters = [NSMutableDictionary dictionaryWithObject:dictionary forKey:@"posts"];
        self.urlPath = kRecordPostAPI;
    }
    return self;
}

- (NSMutableDictionary *)getParams {
    if (_parameters) {
        return _parameters;
    } else {
        return [NSMutableDictionary dictionary];
    }
}
@end
