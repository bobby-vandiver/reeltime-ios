#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "RTStoryboardViewController.h"

@interface RTRecordVideoViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, RTStoryboardViewController>

+ (instancetype)viewController;

@end
