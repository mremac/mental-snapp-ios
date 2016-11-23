//
//  APIInteractorProvider.h
//  Skeleton
//
//  Created by Systango on 14/08/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APIInteractor;

@interface APIInteractorProvider : NSObject

+ (APIInteractorProvider *)sharedInterface;
- (APIInteractor *)getAPIInetractor;

@end
