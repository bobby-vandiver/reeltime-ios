#import "RTRecordVideoCamera.h"

#import "RTRecordVideoCameraDelegate.h"
#import "RTRecordVideoPreviewView.h"

#import "RTFilePathGenerator.h"

#import "RTLogging.h"
#import <AVFoundation/AVFoundation.h>

static const char *SessionQueueLabel = "in.reeltime.record.video.SessionQueue";
static const char *CaptureQueueLabel = "in.reeltime.record.video.CaptureQueue";

@interface RTRecordVideoCamera () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

@property id<RTRecordVideoCameraDelegate> delegate;
@property (weak, nonatomic) RTRecordVideoPreviewView *previewView;

@property RTFilePathGenerator *filePathGenerator;
@property (readwrite) BOOL recording;

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

@property AVAssetWriter *assetWriter;
@property AVAssetWriterInput *videoAssetWriterInput;
@property AVAssetWriterInput *audioAssetWriterInput;

@end

@implementation RTRecordVideoCamera

+ (instancetype)cameraWithDelegate:(id<RTRecordVideoCameraDelegate>)delegate
                       previewView:(RTRecordVideoPreviewView *)previewView {
    return [[RTRecordVideoCamera alloc] initWithDelegate:delegate previewView:previewView];
}

- (instancetype)initWithDelegate:(id<RTRecordVideoCameraDelegate>)delegate
                     previewView:(RTRecordVideoPreviewView *)previewView {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.previewView = previewView;
        
        self.filePathGenerator = [[RTFilePathGenerator alloc] initWithFileManager:[NSFileManager defaultManager]];
        [self configureSession];
    }
    return self;
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
        self.videoOutputConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
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

- (void)startCapture {
    dispatch_async(self.sessionQueue, ^{
        [self.session startRunning];
    });
}

- (void)stopCapture {
    dispatch_async(self.sessionQueue, ^{
        [self.session stopRunning];
    });
}

- (void)startRecording {
    @synchronized(self) {
        self.recording = YES;
        [self.delegate recordingStarted];
    }
}

- (void)stopRecording {
    @synchronized(self) {
        DDLogDebug(@"Stop recording");
        
        [self.assetWriter finishWritingWithCompletionHandler:^{
            self.recording = NO;
            self.assetWriter = nil;
            [self.delegate recordingStopped];
        }];
    }
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
    
    NSString *tempFilePath = [self.filePathGenerator tempFilePath:@".mp4"];
    NSURL *tempFileUrl = [NSURL fileURLWithPath:tempFilePath];
    
    DDLogDebug(@"tempFileUrl = %@", tempFileUrl);
    
    self.assetWriter = [AVAssetWriter assetWriterWithURL:tempFileUrl
                                                fileType:AVFileTypeMPEG4
                                                   error:&error];
    
    if (!self.assetWriter) {
        DDLogError(@"Failed to create asset writer = %@", error);
    }
    
    //    NSDictionary *videoOutputSettings = [self.videoDataOutput recommendedVideoSettingsForAssetWriterWithOutputFileType:AVFileTypeMPEG4];
    
    CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
    
    NSNumber *videoWidth = @(mainScreenBounds.size.width);
    NSNumber *videoHeight = @(mainScreenBounds.size.height);
    
    DDLogDebug(@"width = %@, height = %@", videoWidth, videoHeight);
    
    NSDictionary *videoOutputSettings = @{
                                          AVVideoCodecKey: AVVideoCodecH264,
                                          AVVideoWidthKey: videoWidth,
                                          AVVideoHeightKey: videoHeight
                                          };
    
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

@end
