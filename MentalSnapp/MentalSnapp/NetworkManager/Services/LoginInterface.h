//
//  LoginInterface.h
//  Skeleton
//
//  Created by Systango on 18/12/13.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LogoutRequest;
@interface LoginInterface : NSObject{
    NSObject *_target;
    SEL _callBack;
}

//- (void)loginWithFacebookUser:(SocialUser *)socialUser target:(NSObject *)target callBack:(SEL)callBack;
//
//- (void)loginUser:(User *)user target:(NSObject *)target callBack:(SEL)callBack;
//
//- (void)logoutUser:(LogoutRequest *)logoutRequest target:(NSObject *)target callBack:(SEL)callBack;
//
//- (void)signupUser:(User *)user target:(NSObject *)target callBack:(SEL)callBack;
//
//- (void)checkUserNameAvailability:(UserAvailabilityRequest *)userAvailability target:(NSObject *)target callBack:(SEL)callBack;
//
//- (void)checkEmailAvailability:(UserAvailabilityRequest *)userAvailability target:(NSObject *)target callBack:(SEL)callBack;
//
//- (void)forgotUserName:(ForgotUserRequest *)forgotUserRequest target:(NSObject *)target callBack:(SEL)callBack;
//
//- (void)forgotPassword:(ForgotUserRequest *)forgotUserRequest target:(NSObject *)target callBack:(SEL)callBack;

- (NSMutableArray *)getSavedSessionCookies;

- (BOOL)setSavedSessionCookies;

- (void)saveSessionCookies:(NSString *)urlPath;

- (void)clearSavedSessionCookies;

@end
