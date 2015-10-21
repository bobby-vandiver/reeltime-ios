#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "RTStoryboardViewController.h"

@class RTRecordVideoPreviewView;

@interface RTRecordVideoViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet RTRecordVideoPreviewView *previewView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

+ (instancetype)viewController;

- (IBAction)pressedRecordButton;

@end
