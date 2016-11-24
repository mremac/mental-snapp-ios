//
//  LoginRequest.h
//  MentalSnapp
//

#import "Request.h"

@interface LoginRequest : Request

- (id)initWithLoginUserModel:(UserModel *)userModel;

- (NSMutableDictionary *)getParams;

@end
