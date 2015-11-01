#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "RTRecordVideoCameraDelegate.h"
#import "RTStoryboardViewController.h"

@class RTRecordVideoCamera;
@class RTRecordVideoPreviewView;

@interface RTRecordVideoViewController : UIViewController <RTRecordVideoCameraDelegate, RTStoryboardViewController>

@property (weak, nonatomic) IBOutlet RTRecordVideoPreviewView *previewView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

+ (instancetype)viewController;

- (IBAction)pressedRecordButton;

@end
