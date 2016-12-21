//
//  VideoTableViewCell.m
//  MentalSnapp
//
//  Created by Systango on 13/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "RecordPost.h"

@interface VideoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (copy, nonatomic) void (^playBlock)(BOOL success, id response);
@property (copy, nonatomic) void (^downloadBlock)(BOOL success, id response);
@property (nonatomic, strong) RecordPost *recordPost;

@end

@implementation VideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.videoImageView.layer.borderWidth = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Public methods

- (void)assignRecordPost:(RecordPost *)recordPost playBlock:(completionBlock)playBlock downloadBlock:(completionBlock)downloadBlock
{
    self.recordPost = recordPost;
    self.playBlock = playBlock;
    self.downloadBlock = downloadBlock;
    NSString *a = recordPost.postDesciption;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:a];
    NSRange foundRange = [a rangeOfString:@"#"];
    
    while (foundRange.location != NSNotFound)
    {
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:15.0/255.0 green:175.0/255.0 blue:198.0/255.0 alpha:1.0] range:foundRange];
        
        NSRange rangeToSearch;
        rangeToSearch.location = foundRange.location + foundRange.length;
        rangeToSearch.length = a.length - rangeToSearch.location;
        foundRange = [a rangeOfString:@"#" options:0 range:rangeToSearch];
    }
    
    self.descriptionLabel.attributedText = att;
    self.timeLabel.text = [Util displayDateWithTimeInterval:[recordPost.createdAt integerValue]];
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:recordPost.coverURL] placeholderImage:[UIImage imageNamed:@"video_placeholder"]];
    self.videoImageView.layer.borderColor = [[Util getMoodColor:recordPost.moodId.length > 0 ? [recordPost.moodId integerValue] : KNone] CGColor];
}

#pragma mark - IBActions

- (IBAction)playButtonTapped:(id)sender {
    self.playBlock(YES, self.recordPost);
}
- (IBAction)dowloadButtonTapped:(id)sender {
    self.downloadBlock(YES, self.recordPost);
}




@end
