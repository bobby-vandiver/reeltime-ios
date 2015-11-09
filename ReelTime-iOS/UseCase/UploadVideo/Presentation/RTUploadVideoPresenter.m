#import "RTUploadVideoPresenter.h"

#import "RTUploadVideoView.h"
#import "RTUploadVideoInteractor.h"
#import "RTUploadVideoWireframe.h"

#import "RTUploadVideoError.h"

#import "RTUploadVideoErrorCodeToErrorMessageMapping.h"
#import "RTErrorCodeToErrorMessagePresenter.h"

#import "RTLogging.h"

@interface RTUploadVideoPresenter ()

@property id<RTUploadVideoView> view;
@property RTUploadVideoInteractor *interactor;
@property RTUploadVideoWireframe *wireframe;
@property RTErrorCodeToErrorMessagePresenter *errorPresenter;

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
        
        RTUploadVideoErrorCodeToErrorMessageMapping *mapping = [[RTUploadVideoErrorCodeToErrorMessageMapping alloc] init];
        self.errorPresenter = [[RTErrorCodeToErrorMessagePresenter alloc] initWithDelegate:self mapping:mapping];
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
    DDLogInfo(@"Uploaded video: %@", video);
    [self.wireframe presentVideoCameraInterface];
}

- (void)uploadFailedWithErrors:(NSArray *)errors {
    [self.errorPresenter presentErrors:errors];
}

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code {
    switch (code) {
        case RTUploadVideoErrorMissingReelName:
        case RTUploadVideoErrorInvalidReelName:
        case RTUploadVideoErrorUnknownReel:
            [self.view showValidationErrorMessage:message forField:RTUploadVideoViewFieldReelName];
            break;
            
        case RTUploadVideoErrorMissingVideoTitle:
        case RTUploadVideoErrorInvalidVideoTitle:
            [self.view showValidationErrorMessage:message forField:RTUploadVideoViewFieldVideoTitle];
            break;
            
        case RTUploadVideoErrorMissingThumbnail:
        case RTUploadVideoErrorInvalidThumbnail:
        case RTUploadVideoErrorMissingVideo:
        case RTUploadVideoErrorInvalidVideo:
        case RTUploadVideoErrorServiceUnavailable:
        case RTUploadVideoErrorUnknownError:
            [self.view showErrorMessage:message];
            break;
            
        default:
            break;
    }
}

@end
