//
//  APIInteractor.h
//  Skeleton
//
//  Created by Systango on 14/08/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Request;

@protocol APIInteractor <NSObject>

@required

- (void)putObject:(Request *)request withCompletionBlock:(completionBlock)block;

- (void)getObject:(Request *)request withCompletionBlock:(completionBlock)block;

- (void)postObject:(Request *)request withCompletionBlock:(completionBlock)block;

- (void)deleteObject:(Request *)request withCompletionBlock:(completionBlock)block;

- (void)multiPartObjectPost:(Request *)request withCompletionBlock:(completionBlock)block;

- (void)multiPartObjectPut:(Request *)request withCompletionBlock:(completionBlock)block;

@end
