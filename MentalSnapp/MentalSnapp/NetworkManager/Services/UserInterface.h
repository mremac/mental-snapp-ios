//
//  UserInterface.h
//  MentalSnapp
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserRequest.h"

@interface UserInterface : NSObject

@property (nonatomic, strong) void (^block)(BOOL success, id response);

    
- (void)editUserWithRequest:(UserRequest *)userRequest andCompletionBlock:(completionBlock)block;
    
@end
