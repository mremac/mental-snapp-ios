//
//  RecordViewController.h
//  MentalSnapp
//

#import "MSViewController.h"
#import "GuidedExcerciseViewController.h"

@interface RecordViewController : MSViewController

@property(nonatomic, strong) GuidedExcercise *exercise;
@property (assign, nonatomic) NSInteger viewTag;
@property (assign, nonatomic) BOOL isExerciseView;

@end
