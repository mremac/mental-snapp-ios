//
//  RequestManager.m
//  Skeleton
//
//  Created by Systango on 14/08/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "RequestManager.h"
#import "UserInterface.h"
#import "UserRequest.h"

NSString *const kDefaultErrorMessage =  @"Error! Please try again.";

@implementation RequestManager

#pragma mark - Register Device Token Request

//- (void)registerDeviceTokenWithCompletionBlock:(completionBlock)block {
//    if([ApplicationDelegate hasNetworkAvailable]) {
//        [[DeviceRegistrationInterface alloc] registerDeviceToken:[[Request alloc] initForDeviceRegistration] withCompletionBlock:^(BOOL success, id response) {
//            if (success) {
//                block(success, response);
//            } else{
//                block(NO, nil);
//            }
//        }];
//    } else {
//        block(NO, nil);
//    }
//}

- (void)loginWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block {
//    if ([ApplicationDelegate hasNetworkAvailable]) {
    
//    }
}
- (void)editUserWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block {
        if ([ApplicationDelegate hasNetworkAvailable]) {
            [[UserInterface alloc] editUserWithRequest:[[UserRequest alloc] initForEditUser:userModel] andCompletionBlock:^(BOOL success, id response) {
                block(success,response);
            }];
        }
}

@end
