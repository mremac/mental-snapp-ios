//
//  QueuedExercisesTableViewCell.m
//  MentalSnapp
//
//  Created by Systango on 02/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "QueuedExercisesTableViewCell.h"
#import "GuidedExcercise.h"


@interface QueuedExercisesTableViewCell()
@property (strong, nonatomic) IBOutlet UIButton *exerciseImageButton;
@property (strong, nonatomic) IBOutlet UILabel *exerciseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *exerciseDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *scheduledTimeLabel;

@end

@implementation QueuedExercisesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentsFromSchedule:(ScheduleModel *)schedule
{
    [self.exerciseImageButton sd_setImageWithURL:[NSURL URLWithString:schedule.exercise.coverURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultExcerciseImage"]];
    [self.exerciseTitleLabel setText:schedule.exercise.excerciseName];
    [self.exerciseDescriptionLabel setText:schedule.exercise.excerciseDescription];
    
    if(schedule.executeAt.length > 0)
        [self displayDateWithTimeInterval:[schedule.executeAt integerValue]];
}

- (void)displayDateWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate *dateAndTime = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd MMM."];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"h:mm a"];
    
    NSString *relativeDateValue = [dateAndTime isToday] ? @"Today" : [dateAndTime isTomorrow] ? @"Tomorrow" : [dateFormatter stringFromDate:dateAndTime];
    
    [self.scheduledTimeLabel setText:[NSString stringWithFormat:@"%@\n%@", relativeDateValue, [[timeFormatter stringFromDate:dateAndTime] lowercaseString]]];
}

@end
