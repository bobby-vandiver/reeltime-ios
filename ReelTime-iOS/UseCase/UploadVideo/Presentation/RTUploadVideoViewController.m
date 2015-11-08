#import "RTUploadVideoViewController.h"
#import "RTUploadVideoPresenter.h"

#import "RTStoryboardViewControllerFactory.h"

@interface RTUploadVideoViewController ()

@property RTUploadVideoPresenter *presenter;

@property NSURL *videoUrl;
@property NSURL *thumbnailUrl;

@end

@implementation RTUploadVideoViewController

+ (instancetype)viewControllerWithPresenter:(RTUploadVideoPresenter *)presenter
                                   forVideo:(NSURL *)videoUrl
                                  thumbnail:(NSURL *)thumbnailUrl {

    RTUploadVideoViewController *controller = [RTStoryboardViewControllerFactory storyboardViewController:self];
    
    if (controller) {
        controller.presenter = presenter;
        controller.videoUrl = videoUrl;
        controller.thumbnailUrl = thumbnailUrl;
    }
    
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Upload Video View Controller";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.videoTitleField.text = @"";
    self.reelNameField.text = @"";
}

- (IBAction)pressedSubmitButton {
    [self.presenter requestedUploadForVideo:self.videoUrl
                              withThumbnail:self.thumbnailUrl
                                 videoTitle:self.videoTitleField.text
                             toReelWithName:self.reelNameField.text];
}

- (void)showValidationErrorMessage:(NSString *)message
                          forField:(NSInteger)field {
    [self showErrorMessage:message];
}

- (void)showErrorMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
