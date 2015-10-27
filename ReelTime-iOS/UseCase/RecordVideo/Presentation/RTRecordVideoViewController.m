#import "RTRecordVideoViewController.h"
#import "RTRecordVideoPreviewView.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTLogging.h"

#import <AssetsLibrary/AssetsLibrary.h>

static const char *SessionQueueLabel = "in.reeltime.record.video.SessionQueue";
static const char *CaptureQueueLabel = "in.reeltime.record.video.CaptureQueue";

@interface RTRecordVideoViewController () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

@property BOOL recording;

@property dispatch_queue_t sessionQueue;
@property dispatch_queue_t captureQueue;

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
    self.captureQueue = dispatch_queue_create(CaptureQueueLabel, DISPATCH_QUEUE_SERIAL);

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
        
        self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];        
        [self.videoDataOutput setSampleBufferDelegate:self queue:self.captureQueue];
        
        if ([self.session canAddOutput:self.videoDataOutput]) {
            [self.session addOutput:self.videoDataOutput];
        }
        else {
            DDLogError(@"Could not add video data output to session");
        }
        
        self.videoOutputConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
        
        self.audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
        [self.audioDataOutput setSampleBufferDelegate:self queue:self.captureQueue];
        
        if ([self.session canAddOutput:self.audioDataOutput]) {
            [self.session addOutput:self.audioDataOutput];
        }
        else {
            DDLogError(@"Could not add audio data output to session");
        }
        
        self.audioOutputConnection = [self.audioDataOutput connectionWithMediaType:AVMediaTypeAudio];

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
    @synchronized(self) {
        DDLogDebug(@"Start recording");
        self.recording = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.recordButton setTitle:@"Stop" forState:UIControlStateNormal];
        });
    }
}

- (void)stopRecording {
    @synchronized(self) {
        DDLogDebug(@"Stop recording");

        [self.assetWriter finishWritingWithCompletionHandler:^{
            self.recording = NO;
            self.assetWriter = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
            });
        }];
    }
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
    
    @synchronized(self) {
        if (!self.recording) {
            return;
        }
        
        if (!self.assetWriter) {
            [self initAssetWriter];
        }
    }
    
    if (CMSampleBufferDataIsReady(sampleBuffer)) {
        
        if (self.assetWriter.status == AVAssetWriterStatusUnknown) {
            CMTime startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            
            [self.assetWriter startWriting];
            [self.assetWriter startSessionAtSourceTime:startTime];
        }
        
        if (self.assetWriter.status == AVAssetWriterStatusFailed) {
            DDLogError(@"Writer failed with error = %@", self.assetWriter.error);
            return;
        }
        
        if (connection == self.videoOutputConnection && self.videoAssetWriterInput.isReadyForMoreMediaData) {
            [self.videoAssetWriterInput appendSampleBuffer:sampleBuffer];
        }
        else if (connection == self.audioOutputConnection && self.audioAssetWriterInput.isReadyForMoreMediaData) {
            [self.audioAssetWriterInput appendSampleBuffer:sampleBuffer];
        }
    }
}

- (void)initAssetWriter {
    NSError *error;
    
    NSURL *tempFileUrl = [NSURL fileURLWithPath:[self tempFilePath]];
    DDLogDebug(@"tempFileUrl = %@", tempFileUrl);
    
    self.assetWriter = [AVAssetWriter assetWriterWithURL:tempFileUrl
                                                fileType:AVFileTypeMPEG4
                                                   error:&error];
    
    if (!self.assetWriter) {
        DDLogError(@"Failed to create asset writer = %@", error);
    }
    
    NSDictionary *videoOutputSettings = [self.videoDataOutput recommendedVideoSettingsForAssetWriterWithOutputFileType:AVFileTypeMPEG4];
    
    self.videoAssetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoOutputSettings];
    self.videoAssetWriterInput.expectsMediaDataInRealTime = YES;
    
    if ([self.assetWriter canAddInput:self.videoAssetWriterInput]) {
        [self.assetWriter addInput:self.videoAssetWriterInput];
    }
    else {
        DDLogError(@"Could not add video asset writer input to asset writer");
    }
    
    NSDictionary *audioOutputSettings = [self.audioDataOutput recommendedAudioSettingsForAssetWriterWithOutputFileType:AVFileTypeMPEG4];
    
    self.audioAssetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioOutputSettings];
    self.audioAssetWriterInput.expectsMediaDataInRealTime = YES;
    
    if ([self.assetWriter canAddInput:self.audioAssetWriterInput]) {
        [self.assetWriter addInput:self.audioAssetWriterInput];
    }
    else {
        DDLogError(@"Could not add audio asset writer input to asset writer");
    }
}

- (NSString *)tempFilePath {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *filename = [uuid stringByAppendingString:@".mp4"];
    
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
