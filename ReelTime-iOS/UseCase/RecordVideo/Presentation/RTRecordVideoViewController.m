#import "RTRecordVideoViewController.h"
#import "RTRecordVideoPreviewView.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTLogging.h"

#import <AssetsLibrary/AssetsLibrary.h>

static const char *SessionQueueLabel = "in.reeltime.record.video.session.queue";

static const char *VideoOutputQueueLabel = "in.reeltime.record.video.video.output.queue";
static const char *AudioOutputQueueLabel = "in.reeltime.record.video.audio.output.queue";

@interface RTRecordVideoViewController () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate>

@property BOOL recording;

@property dispatch_queue_t sessionQueue;
@property dispatch_queue_t videoOutputQueue;
@property dispatch_queue_t audioOutputQueue;

@property AVCaptureSession *session;

@property AVCaptureDevice *videoDevice;
@property AVCaptureDeviceInput *videoDeviceInput;

@property AVCaptureVideoDataOutput *videoDataOutput;
@property AVCaptureConnection *videoOutputConnection;

@property AVCaptureDevice *audioDevice;
@property AVCaptureDeviceInput *audioDeviceInput;

@property AVCaptureAudioDataOutput *audioDataOutput;
@property AVCaptureConnection *audioOutputConnection;

@property AVCaptureMovieFileOutput *movieFileOutput;

@property AVAssetWriter *assetWriter;
@property AVAssetWriterInput *videoAssetWriterInput;
@property AVAssetWriterInput *audioAssetWriterInput;

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
    [self configureSession];
}

- (void)configureSession {
    self.session = [[AVCaptureSession alloc] init];
    self.previewView.session = self.session;

    self.sessionQueue = dispatch_queue_create(SessionQueueLabel, DISPATCH_QUEUE_SERIAL);

    dispatch_async(self.sessionQueue, ^{
        NSError *error;

        [self.session beginConfiguration];
        
        self.videoDevice = [self frontCamera];
        self.videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:&error];
        
        if (!self.videoDeviceInput) {
            DDLogError(@"Failed to create video device input = %@", error);
        }
        
        if ([self.session canAddInput:self.videoDeviceInput]) {
            [self.session addInput:self.videoDeviceInput];
        }
        else {
            DDLogError(@"Could not add video device input to session");
        }
        
        self.audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        self.audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.audioDevice error:&error];
        
        if (!self.audioDeviceInput) {
            DDLogError(@"Failed to create audio device input = %@", error);
        }
        
        if ([self.session canAddInput:self.audioDeviceInput]) {
            [self.session addInput:self.audioDeviceInput];
        }
        else {
            DDLogError(@"Could not add audio device input to session");
        }
        
//        self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
//        self.videoOutputQueue = dispatch_queue_create(VideoOutputQueueLabel, DISPATCH_QUEUE_SERIAL);
//        
//        [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoOutputQueue];
//        
//        if ([self.session canAddOutput:self.videoDataOutput]) {
//            [self.session addOutput:self.videoDataOutput];
//        }
//        else {
//            DDLogError(@"Could not add video data output to session");
//        }
//        
//        self.videoOutputConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
//        
//        self.audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
//        self.audioOutputQueue = dispatch_queue_create(AudioOutputQueueLabel, DISPATCH_QUEUE_SERIAL);
//        
//        [self.audioDataOutput setSampleBufferDelegate:self queue:self.audioOutputQueue];
//        
//        if ([self.session canAddOutput:self.audioDataOutput]) {
//            [self.session addOutput:self.audioDataOutput];
//        }
//        else {
//            DDLogError(@"Could not add audio data output to session");
//        }
//        
//        self.audioOutputConnection = [self.audioDataOutput connectionWithMediaType:AVMediaTypeAudio];

        self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        
        if ([self.session canAddOutput:self.movieFileOutput]) {
            [self.session addOutput:self.movieFileOutput];
        }
        else {
            DDLogError(@"Could not add movie file output to session");
        }
        
        [self.session commitConfiguration];
    });
}

- (AVCaptureDevice *)frontCamera {
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"position == %d", AVCaptureDevicePositionFront];

    NSArray *filteredDevices = [videoDevices filteredArrayUsingPredicate:predicate];
    return filteredDevices.count > 0 ? filteredDevices[0] : nil;
}

- (IBAction)pressedRecordButton {
    !self.recording ? [self startRecording] : [self stopRecording];
}

- (void)startRecording {
    self.recording = YES;
    
    [self.recordButton setTitle:@"Stop" forState:UIControlStateNormal];

    dispatch_async(self.sessionQueue, ^{
//        NSError *error;
        
        NSURL *tempFileUrl = [NSURL fileURLWithPath:[self tmpFile]];
        DDLogDebug(@"tempFileUrl = %@", tempFileUrl);

        [self.movieFileOutput startRecordingToOutputFileURL:tempFileUrl recordingDelegate:self];

//        self.assetWriter = [AVAssetWriter assetWriterWithURL:tempFileUrl
//                                                    fileType:AVFileTypeMPEG4
//                                                       error:&error];
//
//        if (!self.assetWriter) {
//            DDLogError(@"Failed to create asset writer = %@", error);
//        }
//
//        self.videoAssetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:nil];
//        self.videoAssetWriterInput.expectsMediaDataInRealTime = YES;
//
//        if ([self.assetWriter canAddInput:self.videoAssetWriterInput]) {
//            [self.assetWriter addInput:self.videoAssetWriterInput];
//        }
//        else {
//            DDLogError(@"Could not add video asset writer input to asset writer");
//        }
//
//        self.audioAssetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:nil];
//        self.audioAssetWriterInput.expectsMediaDataInRealTime = YES;
//
//        if ([self.assetWriter canAddInput:self.audioAssetWriterInput]) {
//            [self.assetWriter addInput:self.audioAssetWriterInput];
//        }
//        else {
//            DDLogError(@"Could not add audio asset writer input to asset writer");
//        }
//        
//        [self.assetWriter startWriting];
//        [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
    });
}

- (void)stopRecording {
    dispatch_async(self.sessionQueue, ^{
        
//        [self.assetWriter finishWritingWithCompletionHandler:^{
            DDLogDebug(@"finished writing");
            self.recording = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
        });
//        }];

        [self.movieFileOutput stopRecording];
        
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(self.sessionQueue, ^{
        [self.session startRunning];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    dispatch_async(self.sessionQueue, ^{
        [self.session stopRunning];
    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

//    if (!self.recording) {
//        return;
//    }
//    
//    CMTime timeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
//    
//    if (CMTIME_IS_INVALID(timeStamp)) {
//        NSString *timeStampDescription = (NSString *)CFBridgingRelease(CMTimeCopyDescription(NULL, timeStamp));
//
//        DDLogError(@"timeStamp = %@ is invalid", timeStampDescription);
//        return;
//    }
   
//    if (CMSampleBufferDataIsReady(sampleBuffer)) {
//        if (self.assetWriter.status == AVAssetWriterStatusUnknown) {
//            DDLogWarn(@"AVAssetWriterStatusUnknown");
//            return;
//        }
//        else if (self.assetWriter.status == AVAssetWriterStatusFailed) {
//            DDLogError(@"AVAssetWriterStatusFailed -- error = %@", self.assetWriter.error);
//            return;
//        }
//        
//        if (connection == self.videoOutputConnection && [self.videoAssetWriterInput isReadyForMoreMediaData]) {
//            dispatch_async(self.videoOutputQueue, ^{
//                [self.videoAssetWriterInput appendSampleBuffer:sampleBuffer];
//            });
//        }
//        else if (connection == self.audioOutputConnection && [self.audioAssetWriterInput isReadyForMoreMediaData]) {
//            dispatch_async(self.audioOutputQueue, ^{
//                [self.audioAssetWriterInput appendSampleBuffer:sampleBuffer];
//            });
//        }
//    }
//    
    
//    [self.assetWriter startSessionAtSourceTime:timeStamp];
    
//    if (connection == self.videoOutputConnection) {
//        [self.videoAssetWriterInput appendSampleBuffer:sampleBuffer];
//    }
//    else if (connection == self.audioOutputConnection) {
//        [self.audioAssetWriterInput appendSampleBuffer:sampleBuffer];
//    }
//    
//    [self.assetWriter endSessionAtSourceTime:timeStamp];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    DDLogDebug(@"started recording");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    if (error) {
        DDLogError(@"recording failed with error = %@", error);
    }
    else {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
                                        completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 if (error)
                 {
                     
                 }
             }];
        }
    }
}

- (NSString *)tmpFile {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *filename = [uuid stringByAppendingString:@".mov"];
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:filename];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error;

        if (![fileManager removeItemAtPath:path error:&error]) {
            DDLogError(@"Failed to remove item at %@ due to error = %@", path, error);
        }
    }
    
    return path;
}

@end
