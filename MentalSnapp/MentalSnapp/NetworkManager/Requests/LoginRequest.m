//
//  LoginRequest.m
//  MentalSnapp
//

#import "LoginRequest.h"

@interface LoginRequest ()

@property (nonatomic, strong) NSMutableDictionary *parameters;

@end

@implementation LoginRequest

- (id)initWithLoginUserModel:(UserModel *)userModel {
    self = [super init];
    if (self) {
        _parameters = [[userModel toDictionary] mutableCopy];
        
        self.urlPath = kLoginAPI;
    }
    return self;
}

- (id)initWithSignUpUserModel:(UserModel *)userModel {
    self = [super init];
    if (self) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:[[userModel toDictionary] mutableCopy] forKey:@"user"];
        _parameters = dict;
        
        self.urlPath = kSignUpAPI;
    }
    return self;
}

- (id)initWithForgotPassEmail:(NSString *)email {
    self = [super init];
    if (self) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:[@{@"email": email} mutableCopy] forKey:@"user"];
        _parameters = dict;
        
        self.urlPath = kForgotPassAPI;
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
