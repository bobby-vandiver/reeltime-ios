#import "RTCaptureThumbnailViewController.h"
#import "RTCaptureThumbnailPresenter.h"
#import "RTStoryboardViewControllerFactory.h"

@interface RTCaptureThumbnailViewController ()

@property RTCaptureThumbnailPresenter *presenter;
@property (copy) NSURL *videoURL;

@end

@implementation RTCaptureThumbnailViewController

+ (instancetype)viewControllerWithPresenter:(RTCaptureThumbnailPresenter *)presenter
                                   forVideo:(NSURL *)videoURL {
    RTCaptureThumbnailViewController *controller = [RTStoryboardViewControllerFactory storyboardViewController:self];
    
    if (controller) {
        controller.presenter = presenter;
        controller.videoURL = videoURL;
    }

    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Capture Thumbnail View Controller";
}

- (IBAction)pressedCaptureButton {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"boogie2988-rage" ofType:@"png"];

    NSURL *placeholderThumbnailURL = [NSURL fileURLWithPath:path];
    [self.presenter capturedThumbnail:placeholderThumbnailURL forVideo:self.videoURL];
}

@end
