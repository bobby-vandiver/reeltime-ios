#import "RTRecordVideoViewController.h"

#import "RTStoryboardViewControllerFactory.h"
#import "RTLogging.h"

static const char *SessionQueueLabel = "in.reeltime.record.video.session.queue";

static const char *VideoOutputQueueLabel = "in.reeltime.record.video.video.output.queue";
static const char *AudioOutputQueueLabel = "in.reeltime.record.video.audio.output.queue";

@interface RTRecordVideoViewController ()

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

@property AVAssetWriter *assetWriter;
@property AVAssetWriterInput *videoAssetWriterInput;
@property AVAssetWriterInput *audioAssetWriterInput;

@property AVCaptureVideoPreviewLayer *previewLayer;

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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
                self.previewLayer.frame = self.view.bounds;
                
                [self.view.layer addSublayer:self.previewLayer];
            });
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
        self.videoOutputQueue = dispatch_queue_create(VideoOutputQueueLabel, DISPATCH_QUEUE_SERIAL);

        [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoOutputQueue];

        if ([self.session canAddOutput:self.videoDataOutput]) {
            [self.session addOutput:self.videoDataOutput];
        }
        else {
            DDLogError(@"Could not add video data output to session");
        }
        
        self.videoOutputConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
        
        self.audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
        self.audioOutputQueue = dispatch_queue_create(AudioOutputQueueLabel, DISPATCH_QUEUE_SERIAL);
        
        [self.audioDataOutput setSampleBufferDelegate:self queue:self.audioOutputQueue];
        
        if ([self.session canAddOutput:self.audioDataOutput]) {
            [self.session addOutput:self.audioDataOutput];
        }
        else {
            DDLogError(@"Could not add audio data output to session");
        }
        
        self.audioOutputConnection = [self.audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
        
//        NSURL *tempFileUrl = [NSURL URLWithString:[self tmpFile]];
//        
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
        
        [self.session commitConfiguration];
    });
}

- (AVCaptureDevice *)frontCamera {
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"position == %d", AVCaptureDevicePositionFront];

    NSArray *filteredDevices = [videoDevices filteredArrayUsingPredicate:predicate];
    return filteredDevices.count > 0 ? filteredDevices[0] : nil;
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

    if (connection == self.videoOutputConnection) {
        DDLogDebug(@"Captured video output");
    }
    else if (connection == self.audioOutputConnection) {
        DDLogDebug(@"Captured audio output");
    }
}

// TODO: Move to shared location
// Source: http://joris.kluivers.nl/blog/2009/11/12/creating-temporary-files/

- (NSString *)tmpFile {
    NSString *tempFileTemplate = [NSTemporaryDirectory()
                                  stringByAppendingPathComponent:@"recording-XXXXXX.caf"];
    
    const char *tempFileTemplateCString =
    [tempFileTemplate fileSystemRepresentation];
    
    char *tempFileNameCString = (char *)malloc(strlen(tempFileTemplateCString) + 1);
    strcpy(tempFileNameCString, tempFileTemplateCString);
    int fileDescriptor = mkstemps(tempFileNameCString, 4);
    
    // no need to keep it open
    close(fileDescriptor);
    
    if (fileDescriptor == -1) {
        NSLog(@"Error while creating tmp file");
        return nil;
    }
    
    NSString *tempFileName = [[NSFileManager defaultManager]
                              stringWithFileSystemRepresentation:tempFileNameCString
                              length:strlen(tempFileNameCString)];
    
    free(tempFileNameCString);
    
    return tempFileName;
}

@end
