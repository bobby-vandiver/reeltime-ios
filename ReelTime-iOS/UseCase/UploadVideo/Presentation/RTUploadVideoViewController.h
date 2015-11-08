#import <UIKit/UIKit.h>

#import "RTUploadVideoView.h"
#import "RTStoryboardViewController.h"

@class RTUploadVideoPresenter;

@interface RTUploadVideoViewController : UIViewController <RTUploadVideoView, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet UITextField *videoTitleField;
@property (weak, nonatomic) IBOutlet UITextField *reelNameField;

+ (instancetype)viewControllerWithPresenter:(RTUploadVideoPresenter *)presenter
                                   forVideo:(NSURL *)videoUrl
                                  thumbnail:(NSURL *)thumbnailUrl;

- (IBAction)pressedSubmitButton;

@end
