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
        _parameters = [[user toDictionary] mutableCopy];
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
        self.urlPath = [NSString stringWithFormat:KUserAPI,user.userId];
    }
    return self;
}


- (id)initForChangePassword:(NSString *)currentPassword andNewPassword:(NSString *)newPassword {
    self = [super init];
    if (self) {
        _parameters = [[NSMutableDictionary alloc] init];
        [_parameters setValue:currentPassword forKey:@""];
        [_parameters setValue:newPassword forKey:@""];
        self.urlPath = @"";
    }
    return self;
}


    
@end
