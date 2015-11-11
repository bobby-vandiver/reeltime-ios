#import "RTRecordVideoViewController.h"
#import "RTRecordVideoPresenter.h"

#import "RTRecordVideoCamera.h"
#import "RTRecordVideoPreviewView.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTLogging.h"

@interface RTRecordVideoViewController ()

@property RTRecordVideoPresenter *presenter;
@property RTRecordVideoCamera *camera;

@end

@implementation RTRecordVideoViewController

+ (instancetype)viewControllerWithPresenter:(RTRecordVideoPresenter *)presenter {
    RTRecordVideoViewController *controller = [RTStoryboardViewControllerFactory storyboardViewController:self];
    
    if (controller) {
        controller.presenter = presenter;
    }
    
    return controller;
}

+ (NSString *)storyboardIdentifier {
    return @"Record Video View Controller";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.camera = [RTRecordVideoCamera cameraWithDelegate:self previewView:self.previewView];
}

- (IBAction)pressedRecordButton {
    !self.camera.isRecording ? [self.camera startRecording] : [self.camera stopRecording];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.camera startCapture];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.camera stopCapture];
}

- (void)recordingStarted {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recordButton setTitle:@"Stop" forState:UIControlStateNormal];
    });
}

- (void)recordingStopped:(NSURL *)videoURL {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];

        DDLogDebug(@"Finished recording video = %@", videoURL);
        [self.presenter recordedVideo:videoURL];
    });
}

@end
