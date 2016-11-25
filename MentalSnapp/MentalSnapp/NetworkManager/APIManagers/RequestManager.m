//
//  RequestManager.m
//  MentalSnapp
//

#import "RequestManager.h"
#import "UserInterface.h"
#import "UserRequest.h"
#import "LoginInterface.h"
#import "LoginRequest.h"

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
        [[LoginInterface alloc] loginWithUserRequest:[[LoginRequest alloc]initWithLoginUserModel:userModel] andCompletionBlock:^(BOOL success, id response) {
            block(success, response);
        }];
//    }
}

- (void)editUserWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block {
        if ([ApplicationDelegate hasNetworkAvailable]) {
            [[UserInterface alloc] editUserWithRequest:[[UserRequest alloc] initForEditUser:userModel] andCompletionBlock:^(BOOL success, id response) {
                block(success,response);
            }];
        }
}

- (void)getUserDetailWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] getUserDetailWithRequest:[[UserRequest alloc] initForUserDetail:userModel] andCompletionBlock:^(BOOL success, id response) {
            block(success,response);
        }];
    }
}


- (void)changePassword:(NSString *)currentPassword andNewPassword:(NSString *)newPassword withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] changePasswordWithRequest:[[UserRequest alloc] initForChangePassword:currentPassword andNewPassword:newPassword] andCompletionBlock:^(BOOL success, id response) {
            block(success,response);
        }];
    }
}

- (void)userLogoutWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] userLogout:[[UserRequest alloc] initForUserDetail:userModel] andCompletionBlock:^(BOOL success, id response) {
            block(success,response);
        }];
    }
}

- (void)userDeactivateWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[UserInterface alloc] userDeactivate:[[UserRequest alloc] initForUserDetail:userModel] andCompletionBlock:^(BOOL success, id response) {
            block(success,response);
        }];
    }
}

@end
