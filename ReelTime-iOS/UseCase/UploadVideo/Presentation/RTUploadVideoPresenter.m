#import "RTUploadVideoPresenter.h"

#import "RTUploadVideoView.h"
#import "RTUploadVideoInteractor.h"
#import "RTUploadVideoWireframe.h"

#import "RTLogging.h"

@interface RTUploadVideoPresenter ()

@property id<RTUploadVideoView> view;

@property RTUploadVideoInteractor *interactor;
@property RTUploadVideoWireframe *wireframe;

@end

@implementation RTUploadVideoPresenter

- (instancetype)initWithView:(id<RTUploadVideoView>)view
                  interactor:(RTUploadVideoInteractor *)interactor
                   wireframe:(RTUploadVideoWireframe *)wireframe {
    self = [super init];
    if (self) {
        self.view = view;
        self.interactor = interactor;
        self.wireframe = wireframe;
    }
    return self;
}

- (void)requestedUploadForVideo:(NSURL *)videoUrl
                  withThumbnail:(NSURL *)thumbnailUrl
                     videoTitle:(NSString *)videoTitle
                 toReelWithName:(NSString *)reelName {
    
    [self.interactor uploadVideo:videoUrl
                       thumbnail:thumbnailUrl
                  withVideoTitle:videoTitle
                  toReelWithName:reelName];
}

- (void)uploadSucceededForVideo:(RTVideo *)video {
    DDLogDebug(@"Uploaded video: %@", video);
    [self.wireframe presentVideoCameraInterface];
}

- (void)uploadFailedWithErrors:(NSArray *)errors {
    
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    
}

@end
