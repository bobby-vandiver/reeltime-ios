#import "RTRecordVideoViewController.h"

#import "RTRecordVideoCamera.h"
#import "RTRecordVideoPreviewView.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTLogging.h"

@interface RTRecordVideoViewController ()

@property RTRecordVideoCamera *camera;

@end

@implementation RTRecordVideoViewController

+ (instancetype)viewController {
    NSString *identifier = [RTRecordVideoViewController storyboardIdentifier];
    RTRecordVideoViewController *controller = [RTStoryboardViewControllerFactory viewControllerWithStoryboardIdentifier:identifier];    
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

- (void)recordingStopped {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    });
}

@end
