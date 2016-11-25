//
//  MoreTableViewCell.h
//  MentalSnapp
//

#import <UIKit/UIKit.h>

@interface MoreTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIButton *headingIconButton;
@property(weak, nonatomic) IBOutlet UILabel *headingLabel;

@property(strong, nonatomic) NSString *iconImageURL;

@end
