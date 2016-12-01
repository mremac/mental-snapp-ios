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

#pragma mark - Login
- (void)loginWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[LoginInterface alloc] loginWithUserRequest:[[LoginRequest alloc]initWithLoginUserModel:userModel] andCompletionBlock:^(BOOL success, id response) {
            block(success, response);
        }];
    }
}

- (void)signUpWithUserModel:(UserModel *)userModel withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[LoginInterface alloc] signUpWithUserRequest:[[LoginRequest alloc] initWithSignUpUserModel:userModel] andCompletionBlock:^(BOOL success, id response) {
            block(success, response);
        }];
    }
}

- (void)forgotPasswordWithEmail:(NSString *)email withCompletionBlock:(completionBlock)block {
    if ([ApplicationDelegate hasNetworkAvailable]) {
        [[LoginInterface alloc] forgotPasswordWithUserRequest:[[LoginRequest alloc] initWithForgotPassEmail:email] andCompletionBlock:^(BOOL success, id response) {
            block(success, response);
        }];
    }
}

#pragma mark - User
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
