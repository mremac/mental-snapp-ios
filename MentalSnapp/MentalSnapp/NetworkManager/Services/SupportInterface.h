//
//  SupportInterface.h
//  MentalSnapp
//
//  Copyright (c) 2015 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SupportRequest;

typedef void (^SupportInterfaceCompletionBlock)(BOOL success, id response);

@interface SupportInterface : NSObject

@property (nonatomic, strong) void (^block)(BOOL success, id response);

- (void)sendSupportRequest:(SupportRequest *)supportRequest withCompletionBlock:(SupportInterfaceCompletionBlock)block;

@end
