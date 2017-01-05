//
//  TermsViewController.h
//  MentalSnapp
//

#import "MSViewController.h"

typedef enum : NSUInteger {
    TermsAndCondition,
    PrivacyPolicy,
} ContentType;

@interface TermsViewController : MSViewController

@property(assign, nonatomic) ContentType contentType;

@end
