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
        
        self.urlPath = @"/authenticate";
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
