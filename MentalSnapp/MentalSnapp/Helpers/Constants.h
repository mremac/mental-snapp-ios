//
//  Constants.h
//  Skeleton
//
//  Created by Systango on 12/22/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define UserDefaults [NSUserDefaults standardUserDefaults]

typedef void (^completionBlock)(BOOL success, id response);

#pragma mark - Constant

extern NSString *const kEmptyString;
extern NSString *const keyDeviceToken;
extern NSString *const kPlistFileName;

#pragma mark - Network keys

extern NSString *const kInsecureProtocol;
extern NSString *const kSecureProtocol;
extern NSString *const kLocalEnviroment;
extern NSString *const kStagingEnviroment;
extern NSString *const kLiveEnviroment;

#pragma mark - Json

extern NSString *const kJsonKeyName;
extern NSString *const kJsonKeyId;

#pragma mark - Numerical Constants

static const int kStatusSuccess = 1;
static const int kResponseStatusSuccess = 200;
static const int kResponseStatusCreated = 201;
static const int kResponseStatusAccepted = 202;
static const int kResponseStatusForbidden = 401;
#pragma mark - Enum

typedef NS_ENUM(NSInteger, RequestType){
    RequestGET,
    RequestPOST,
    RequestMutiPartPost,
    RequestDELETE,
    RequestPUT
};

#pragma mark - Session keys
extern NSString *const kSessionCookies;

#pragma mark - Push Notifications
extern NSString *const kAPSKey;

#pragma mark - Userdefault keys

extern NSString *const kUserEmail;
extern NSString *const kUserPassword;
extern NSString *const kRememberMe;


