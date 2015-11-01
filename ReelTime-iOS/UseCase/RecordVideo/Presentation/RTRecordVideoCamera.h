#import <Foundation/Foundation.h>

@protocol RTRecordVideoCameraDelegate;
@class RTRecordVideoPreviewView;

@interface RTRecordVideoCamera : NSObject

@property (readonly, getter=isRecording) BOOL recording;

+ (instancetype)cameraWithDelegate:(id<RTRecordVideoCameraDelegate>)delegate
                       previewView:(RTRecordVideoPreviewView *)previewView;

- (void)startCapture;

- (void)stopCapture;

- (void)startRecording;

- (void)stopRecording;

@end
