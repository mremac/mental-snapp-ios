//
//  UserRequest.m
//  MentalSnapp
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "UserRequest.h"

@interface UserRequest ()
    
@property (nonatomic, strong) NSMutableDictionary *parameters;
    
@end

@implementation UserRequest
    
- (id)initForEditUser:(UserModel *)user {
    self = [super init];
    if (self) {
        NSMutableDictionary *dictionary = [[user toDictionary] mutableCopy];
        _parameters = [NSMutableDictionary dictionaryWithObject:dictionary forKey:@"user"];
        self.urlPath = [NSString stringWithFormat:KUserAPI,user.userId];
    }
    return self;
}

- (id)initForUserDetail:(UserModel *)user {
    self = [super init];
    if (self) {
        self.urlPath = [NSString stringWithFormat:KUserAPI,user.userId];
    }
    return self;
}

- (id)initForUserLogout:(UserModel *)user {
    self = [super init];
    if (self) {
        self.urlPath = [NSString stringWithFormat:KUserAPI,user.userId];
    }
    return self;
}

- (id)initForUserDeactivate:(UserModel *)user {
    self = [super init];
    if (self) {
        self.urlPath = kDeactivateUser;
    }
    return self;
}


- (id)initForChangePassword:(NSString *)currentPassword andNewPassword:(NSString *)newPassword {
    self = [super init];
    if (self) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:currentPassword forKey:@"current_password"];
        [dictionary setValue:newPassword forKey:@"password"];
        [dictionary setValue:newPassword forKey:@"password_confirmation"];
        _parameters = [NSMutableDictionary dictionaryWithObject:dictionary forKey:@"user"];
        self.urlPath = kChangePassword;
    }
    return self;
}

- (NSMutableDictionary *)getParams {
    if (_parameters) {
        return _parameters;
    } else {
        return [NSMutableDictionary dictionary];
    }
}

    
@end
