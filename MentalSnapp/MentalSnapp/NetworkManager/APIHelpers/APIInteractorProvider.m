//
//  APIInteractorProvider.m
//  Skeleton
//
//  Created by Systango on 14/08/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "APIInteractorProvider.h"
#import "APIInteractor.h"
#import "RealAPI.h"
#import "TestAPI.h"

@implementation APIInteractorProvider

#pragma mark - Singleton Method

+ (APIInteractorProvider *)sharedInterface {
    static APIInteractorProvider *singleton = nil;
    @synchronized(self) {
        if (!singleton) {
            singleton = [[APIInteractorProvider alloc] init];
        }
    }
    return singleton;
}

#pragma mark - Init Method

- (instancetype)init
{
    self = [super init];
    return self;
}

#pragma mark - Public Method

- (APIInteractor *)getAPIInetractor {
    if (YES) {
        return (APIInteractor *)[RealAPI alloc];
    } else {
        return (APIInteractor *)[TestAPI alloc];
    }
}

@end
