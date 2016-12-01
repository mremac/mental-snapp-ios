//
//  LoginRequest.h
//  MentalSnapp
//

#import "Request.h"

@interface LoginRequest : Request

- (id)initWithLoginUserModel:(UserModel *)userModel;

- (id)initWithSignUpUserModel:(UserModel *)userModel;

- (id)initWithForgotPassEmail:(NSString *)email;

- (NSMutableDictionary *)getParams;

@end
