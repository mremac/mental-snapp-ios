//
//  RecordPostInterface.h
//  MentalSnapp
//
//  Created by Systango on 12/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordPostRequest.h"

@interface RecordPostInterface : NSObject

@property (nonatomic, strong) void (^block)(BOOL success, id response);

- (void)getRecordPostsWithRequest:(RecordPostRequest *)recordPostRequest andCompletionBlock:(completionBlock)block;
- (void)postRecordPostWithRequest:(RecordPostRequest *)recordPostRequest andCompletionBlock:(completionBlock)block;


@end
