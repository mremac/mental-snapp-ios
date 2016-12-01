//
//  LoginRequest.h
//  MentalSnapp
//

#import "Request.h"

@interface LoginRequest : Request

- (id)initWithLoginUserModel:(UserModel *)userModel;

- (id)initWithSignUpUserModel:(UserModel *)userModel;

- (NSMutableDictionary *)getParams;

@end
