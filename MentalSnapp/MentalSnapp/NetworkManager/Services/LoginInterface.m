//
//  LoginInterface.m
//  Skeleton
//
//  Created by Systango on 18/12/13.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "LoginInterface.h"

@implementation LoginInterface

/*- (void)loginWithFacebookUser:(SocialUser *)socialUser target:(NSObject *)target callBack:(SEL)callBack
{
    _target = target;
    _callBack = callBack;
    _socialUser = socialUser;
    
    id iVeromuseAPIInteractor = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    if([iVeromuseAPIInteractor isKindOfClass:[RealVeromuseAPI class]])
    {
        RealVeromuseAPI *realVeromuseAPI = (RealVeromuseAPI *)iVeromuseAPIInteractor;
        [realVeromuseAPI loginUser:[[LoginRequest alloc]initWithSocialUser:socialUser] target:self callBack:@selector(loginFacebookRequestCallback:)];
    }
    else if([iVeromuseAPIInteractor isKindOfClass:[TestVeromuseAPI class]])
    {
        TestVeromuseAPI *testVeromuseAPI = (TestVeromuseAPI *)iVeromuseAPIInteractor;
        [testVeromuseAPI loginUser:[[LoginRequest alloc]initWithSocialUser:socialUser] target:self callBack:@selector(loginFacebookRequestCallback:)];
    }
}

- (void)loginUser:(User *)user target:(NSObject *)target callBack: (SEL)callBack
{
    _target = target;
    _callBack = callBack;
    _user = user;
    
    id iVeromuseAPIInteractor = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    if([iVeromuseAPIInteractor isKindOfClass:[RealVeromuseAPI class]])
    {
        RealVeromuseAPI *realVeromuseAPI = (RealVeromuseAPI *)iVeromuseAPIInteractor;
        [realVeromuseAPI loginUser:[[LoginRequest alloc]initWithUser:user] target:self callBack:@selector(loginRequestCallback:)];
    }
    else if([iVeromuseAPIInteractor isKindOfClass:[TestVeromuseAPI class]])
    {
        TestVeromuseAPI *testVeromuseAPI = (TestVeromuseAPI *)iVeromuseAPIInteractor;
        [testVeromuseAPI loginUser:[[LoginRequest alloc]initWithUser:user] target:self callBack:@selector(loginRequestCallback:)];
    }
}

- (void)logoutUser:(LogoutRequest *)logoutRequest target:(NSObject *)target callBack:(SEL)callBack
{
    _target = target;
    _callBack = callBack;
    
    id iVeromuseAPIInteractor = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [iVeromuseAPIInteractor logoutUser:logoutRequest target:self callBack:@selector(logoutRequestCallback:)];

}

- (void)signupUser:(User *)user target:(NSObject *)target callBack:(SEL)callBack
{
    _target = target;
    _callBack = callBack;
    _user = user;
    
    id iVeromuseAPIInteractor = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    if([iVeromuseAPIInteractor isKindOfClass:[RealVeromuseAPI class]])
    {
        RealVeromuseAPI *realVeromuseAPI = (RealVeromuseAPI *)iVeromuseAPIInteractor;
        [realVeromuseAPI signupUser:[[SignupRequest alloc]initWithUser:user] target:self callBack:@selector(signupRequestCallback:)];
    }
    else if([iVeromuseAPIInteractor isKindOfClass:[TestVeromuseAPI class]])
    {
        TestVeromuseAPI *testVeromuseAPI = (TestVeromuseAPI *)iVeromuseAPIInteractor;
        [testVeromuseAPI signupUser:[[SignupRequest alloc]initWithUser:user] target:self callBack:@selector(signupRequestCallback:)];
    }
}

- (void)checkUserNameAvailability:(UserAvailabilityRequest *)userAvailability target:(NSObject *)target callBack:(SEL)callBack
{
    _target = target;
    _callBack = callBack;
     id iVeromuseAPIInteractor = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [iVeromuseAPIInteractor checkUserNameAvailability:userAvailability target:self callBack:@selector(checkUserNameAvailabilityRequestCallback:)];
}

- (void)checkEmailAvailability:(UserAvailabilityRequest *)userAvailability target:(NSObject *)target callBack:(SEL)callBack
{
    _target = target;
    _callBack = callBack;
     id iVeromuseAPIInteractor = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [iVeromuseAPIInteractor checkEmailAvailability:userAvailability target:self callBack:@selector(checkEmailAvailabilityRequestCallback:)];
}

- (void)forgotUserName:(ForgotUserRequest *)forgotUserRequest target:(NSObject *)target callBack:(SEL)callBack
{
    _target = target;
    _callBack = callBack;
    id iVeromuseAPIInteractor = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [iVeromuseAPIInteractor forgotUserName:forgotUserRequest target:self callBack:@selector(forgotUserNameRequestCallback:)];
}

- (void)forgotPassword:(ForgotUserRequest *)forgotUserRequest target:(NSObject *)target callBack:(SEL)callBack
{
    _target = target;
    _callBack = callBack;
    id iVeromuseAPIInteractor = [[APIInteractorProvider sharedInterface] getAPIInetractor];
    [iVeromuseAPIInteractor forgotPassword:forgotUserRequest target:self callBack:@selector(forgotPasswordRequestCallback:)];
}

#pragma mark callback method

- (void)loginRequestCallback:(id)response
{
    [self processLoginResponse:response];
    
    //Code for handle error while login.
    if([response hasValueForKey:@"errors"]) {
        NSDictionary *errors = [response valueForKey:@"errors"];
        if([errors hasValueForKey:@"email"] && [errors[@"email"] isEqualToString:@"E008"] && [errors hasValueForKey:@"msg"]){
            [ApplicationDelegate showFailureBannerOnTopWithTitle:@"User Suspended" subtitle:errors[@"msg"]];
        }else {
            [ApplicationDelegate showFailureBannerOnTopWithTitle:@"Incorrect Username/Password" subtitle:@"Invalid login, please try again or use \"Forgot your password?\" to retrieve your credentials."];
        }
    }   
    
    [self performCallBack:_user];
}

- (void)loginFacebookRequestCallback:(id)response
{
    NSString *errorMessage = @"";
    NSString *errorCode = @"0";
    [self processLoginResponse:response];
    
    if(!_user.isLoggedIn)
    {
//        errorMessage = [Response getErrorMessage:response];
//        if([response hasValueForKey:@"errors"]&&[[response valueForKey:@"errors"] hasValueForKey:@"email"]){
//            errorCode = [[response valueForKey:@"errors"] valueForKey:@"email"];
//        }
    }
    
    NSDictionary *loginUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:_user?_user:[[User alloc] init], KeyUser, errorMessage, KeyContent,errorCode,@"email", nil];
    
    [self performCallBack:loginUserInfo];
}

- (void)processLoginResponse:(id)response
{
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *status = nil;
        if([response hasValueForKey:@"status"])
        {
            status = [response valueForKey:@"status"];
        }
        
        if ([status integerValue] == kStatusSuccess)
        {
            NSDictionary *loginData = [response valueForKey:@"loginData"];
            NSArray *users = nil;
            if([loginData hasValueForKey:@"user"])
            {
                users = [loginData valueForKey:@"user"];
            }
            
            if(users.count)
            {
                NSDictionary *userDict = users[0];
                if(_user == nil) {
                    _user = [[User alloc] init];
                }
                [_user getUserFromJSONDictionary:userDict];
                _user.isLoggedIn = YES;
            }
        }
        else
        {
            NSDictionary *errors = [response valueForKey:@"errors"];
            if(_user == nil) {
                _user = [[User alloc] init];
            }
            _user.isLoggedIn = NO;
            if ([errors hasValueForKey:@"email"])
            {
                _user.email = nil;
            }
            if ([errors hasValueForKey:@"password"])
            {
                _user.password = nil;
            }
            
            if ([response hasValueForKey:@"loginData"])
            {
                NSDictionary *dictionary = [response valueForKey:@"loginData"];
                if ([dictionary hasValueForKey:@"username"])
                {
                    _user.userName = dictionary[@"username"];
                }
            }
            
        }
    }
    else if([response isKindOfClass:[NSError class]])
    {
        if(_user == nil) {
            _user = [[User alloc] init];
        }
        _user.isLoggedIn = NO;
    }
}

- (void)signupRequestCallback:(id)response
{
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *status = nil;
        if([response hasValueForKey:@"status"])
        {
            status = [response valueForKey:@"status"];
        }
        
        if ([status integerValue] == kStatusSuccess)
        {
            NSDictionary *signupData = [response valueForKey:@"signupData"];
            NSArray *users = nil;
            if([signupData hasValueForKey:@"user"])
            {
                users = [signupData valueForKey:@"user"];
            }
            
            if(users.count)
            {
                NSDictionary *userDict = users[0];
                [_user getUserFromJSONDictionary:userDict];
                _user.isLoggedIn = YES;
            }
        }
        else
        {
            NSString *errors = [response valueForKey:@"errors"];
            _user.isLoggedIn = NO;
            NSLog(@"Signup Errors:%@", errors);
        }
    }else if([response isKindOfClass:[NSError class]])
    {
        _user.isLoggedIn = NO;
    }
    [self performCallBack:_user];
}

- (void)logoutRequestCallback:(id)response
{
    Response *fetchedResponse = [[Response alloc] init];
    fetchedResponse.status = NO;
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *status = nil;
        if([response hasValueForKey:@"status"])
        {
            status = [response valueForKey:@"status"];
        }
        
        if ([status integerValue] != kStatusSuccess)
        {
            fetchedResponse.errors = [response valueForKey:@"errors"];
        }
        else
        {
            fetchedResponse.status = YES;
        }
    }
    else if([response isKindOfClass:[NSError class]])
    {
        fetchedResponse.errors = [NSMutableDictionary dictionary];
        [fetchedResponse.errors setValue:[response localizedDescription] forKey:@"message"];
    }
    [self performCallBack:fetchedResponse];
}

- (void)checkUserNameAvailabilityRequestCallback:(id)response
{
    Response *fetchedResponse = [[Response alloc] init];
    fetchedResponse.status = NO;
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *status = nil;
        if([response hasValueForKey:@"status"])
        {
            status = [response valueForKey:@"status"];
        }
        
        if ([status integerValue] != kStatusSuccess)
        {
            fetchedResponse.errors = [response valueForKey:@"errors"];
        }
        else
        {
            fetchedResponse.status = YES;
        }
    }
    else if([response isKindOfClass:[NSError class]])
    {
        fetchedResponse.errors = [NSMutableDictionary dictionary];
        [fetchedResponse.errors setValue:[response localizedDescription] forKey:@"message"];
    }
    [self performCallBack:fetchedResponse];
}

- (void)checkEmailAvailabilityRequestCallback:(id)response
{
    Response *fetchedResponse = [[Response alloc] init];
    fetchedResponse.status = NO;
    if ([response isKindOfClass:[NSDictionary class]])
    {
        NSString *status = nil;
        if([response hasValueForKey:@"status"])
        {
            status = [response valueForKey:@"status"];
        }        
        
        if ([status integerValue] != kStatusSuccess)
        {
            fetchedResponse.errors = [response valueForKey:@"errors"];
        }
        else
        {
            fetchedResponse.status = YES;
        }
    }
    [self performCallBack:fetchedResponse];
}

- (void)forgotUserNameRequestCallback:(id)response
{
    [self performCallBack:response];
}

- (void)forgotPasswordRequestCallback:(id)response
{
    [self performCallBack:response];
}

#pragma mark private method

- (void)performCallBack:(NSObject *)object
{
    if (_target && [_target respondsToSelector: _callBack])
    {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_callBack withObject:object];
        #pragma clang diagnostic pop
    }
}*/


#pragma mark public method

// Session methods
- (NSMutableArray *)getSavedSessionCookies
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *httpCookies = nil;
    
    httpCookies = [userDefaults objectForKey:kSessionCookies];
    return httpCookies;
}

- (BOOL)setSavedSessionCookies
{
    NSMutableArray *httpCookies = [self getSavedSessionCookies];
    if(httpCookies.count)
    {
        for (NSDictionary* cookieProperties in httpCookies)
        {
            NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:cookieProperties];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
        return YES;
    }
    return NO;
}

- (void)saveSessionCookies:(NSString *)urlPath
{
    if([urlPath isEqualToString:@"/api/login"] || [urlPath isEqualToString:@"/api/signup"])
    {
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        NSArray *httpCookies = [cookies cookiesForURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[NetworkHttpClient sharedInstance].baseURL, urlPath]]];
        NSMutableArray *sessionCookies = [[NSMutableArray alloc]init];
        for (NSHTTPCookie* cookie in httpCookies)
        {
            [sessionCookies addObject:cookie.properties];
        }
        
        if(sessionCookies.count)
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:sessionCookies forKey:kSessionCookies];
            [userDefaults synchronize];
        }
    }
}

- (void)clearSavedSessionCookies
{
    for (NSHTTPCookie *cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kSessionCookies];
    [userDefaults synchronize];
}


@end
