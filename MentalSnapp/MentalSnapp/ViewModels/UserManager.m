//
//  UserManager.m
//  MentalSnapp
//

#import "UserManager.h"
#import "LoginViewController.h"

@implementation UserManager

static UserManager *userManager = nil;
static dispatch_once_t userOnceToken;

+ (UserManager *)sharedManager
{
    dispatch_once(&userOnceToken, ^{
        userManager = [[UserManager alloc] init];
    });
    return userManager;
}

- (id)init {
    self = [super init];
    if(self)
    {
        _userModel = [UserModel new];
    }
    
    return self;
}

- (void)saveLoggedinUserInfoInUserDefault
{
    [UserDefaults setBool:YES forKey:kIsUserLoggedIn];
    
    [UserDefaults setValue:_authorizationToken forKey:@"authorizationToken"];
    [UserDefaults setValue:_userModel.email forKey:@"email"];
    [UserDefaults setValue:_userModel.password forKey:@"password"];
    [UserDefaults setValue:_userModel.userName forKey:@"name"];
    [UserDefaults setValue:_userModel.firstName forKey:@"first_name"];
    [UserDefaults setValue:_userModel.userId forKey:@"id"];
    [UserDefaults setValue:_userModel.profilePicURL forKey:@"profile_url"];
    [UserDefaults setValue:_userModel.dateOfBirth forKey:@"date_of_birth"];
    [UserDefaults setValue:_userModel.gender forKey:@"gender"];
    [UserDefaults setValue:_userModel.phoneNumber forKey:@"phone_number"];
    [UserDefaults synchronize];
}

- (void)setValueInLoggedInUserObjectFromUserDefault
{
    _authorizationToken = [UserDefaults valueForKey:@"authorizationToken"];
    _userModel.email = [UserDefaults valueForKey:@"email"];
    _userModel.userName = [UserDefaults valueForKey:@"name"]?:[UserDefaults valueForKey:@"first_name"];
    _userModel.password = [UserDefaults valueForKey:@"password"];
    _userModel.dateOfBirth = [UserDefaults valueForKey:@"date_of_birth"];
    _userModel.phoneNumber = [UserDefaults valueForKey:@"phone_number"];
    _userModel.gender = [UserDefaults valueForKey:@"gender"];
    _userModel.userId = [UserDefaults valueForKey:@"id"];
    _userModel.profilePicURL = [UserDefaults valueForKey:@"profile_url"];
    NSError *error;
    NSDictionary *dictionary = [UserDefaults dictionaryRepresentation];
    _userModel = [[UserModel alloc] initWithDictionary:dictionary error:&error];
}

- (void)updateProfileURL:(NSString *)profileURL
{
    _userModel.profilePicURL = profileURL;
    [UserDefaults setValue:_userModel.profilePicURL forKey:@"profile_url"];
    [UserDefaults synchronize];
}

-(void)logoutUser {
    [self removeUserFromUserDefault];
    [[ScheduleManager sharedInstance] didcleanSchedules];
    LoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [[ApplicationDelegate window] setRootViewController:[[UINavigationController alloc] initWithRootViewController:loginViewController]];
}

//*>    Save Logged in user's info in user default
- (void)removeUserFromUserDefault
{
    [UserDefaults setBool:NO forKey:kIsUserLoggedIn];
    [UserDefaults removeObjectForKey:@"authorizationToken"];
    [UserDefaults removeObjectForKey:@"email"];
    [UserDefaults removeObjectForKey:@"name"];
    [UserDefaults removeObjectForKey:@"password"];
    [UserDefaults removeObjectForKey:@"date_of_birth"];
    [UserDefaults removeObjectForKey:@"phone_number"];
    [UserDefaults removeObjectForKey:@"gender"];
    [UserDefaults removeObjectForKey:@"id"];
    [UserDefaults removeObjectForKey:@"profile_url"];
    [UserDefaults removeObjectForKey:kIsCameraDurationAlertShown];
    [UserDefaults synchronize];
}

+ (BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
