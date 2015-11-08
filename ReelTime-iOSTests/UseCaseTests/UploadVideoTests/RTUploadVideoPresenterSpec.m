#import "RTTestCommon.h"

#import "RTUploadVideoPresenter.h"

#import "RTUploadVideoView.h"
#import "RTUploadVideoInteractor.h"
#import "RTUploadVideoWireframe.h"

#import "RTUploadVideoError.h"
#import "RTErrorFactory.h"

SpecBegin(RTUploadVideoPresenter)

describe(@"upload video presenter", ^{
    
    __block RTUploadVideoPresenter *presenter;
    __block id<RTUploadVideoView> view;
    
    __block RTUploadVideoInteractor *interactor;
    __block RTUploadVideoWireframe *wireframe;

    __block NSURL *videoUrl;
    __block NSURL *thumbnailUrl;
    
    beforeEach(^{
        wireframe = mock([RTUploadVideoWireframe class]);
        interactor = mock([RTUploadVideoInteractor class]);
        
        view = mockProtocol(@protocol(RTUploadVideoView));
        
        presenter = [[RTUploadVideoPresenter alloc] initWithView:view
                                                      interactor:interactor
                                                       wireframe:wireframe];
        
        videoUrl = mock([NSURL class]);
        thumbnailUrl = mock([NSURL class]);
    });
    
    describe(@"requested video upload", ^{
        it(@"should pass parameters to interactor", ^{
            [presenter requestedUploadForVideo:videoUrl withThumbnail:thumbnailUrl videoTitle:videoTitle toReelWithName:reelName];
            [verify(interactor) uploadVideo:videoUrl thumbnail:thumbnailUrl withVideoTitle:videoTitle toReelWithName:reelName];
        });
    });
    
    describe(@"upload succeeded", ^{
        it(@"should present video camera interface", ^{
            [presenter uploadSucceededForVideo:anything()];
            [verify(wireframe) presentVideoCameraInterface];
        });
    });
    
    describe(@"upload failure", ^{
        __block RTErrorPresentationChecker *errorChecker;
        __block RTFieldErrorPresentationChecker *fieldErrorChecker;
        
        ErrorFactoryCallback errorFactoryCallback = ^NSError * (NSInteger code) {
            return [RTErrorFactory uploadVideoErrorWithCode:code];
        };
        
        ArrayCallback errorsCallback = ^(NSArray *errors) {
            [presenter uploadFailedWithErrors:errors];
        };
        
        beforeEach(^{
            errorChecker = [[RTErrorPresentationChecker alloc] initWithView:view
                                                             errorsCallback:errorsCallback
                                                       errorFactoryCallback:errorFactoryCallback];
            
            fieldErrorChecker = [[RTFieldErrorPresentationChecker alloc] initWithView:view
                                                                       errorsCallback:errorsCallback
                                                                 errorFactoryCallback:errorFactoryCallback];
        });

        it(@"missing reel name", ^{
            [fieldErrorChecker verifyErrorMessage:@"Reel name is required"
                              isShownForErrorCode:RTUploadVideoErrorMissingReelName
                                            field:RTUploadVideoViewFieldReelName];
        });
        
        it(@"missing video title", ^{
            [fieldErrorChecker verifyErrorMessage:@"Video title is required"
                              isShownForErrorCode:RTUploadVideoErrorMissingVideoTitle
                                            field:RTUploadVideoViewFieldVideoTitle];
        });
        
        it(@"invalid video title", ^{
            [fieldErrorChecker verifyErrorMessage:@"Video title is invalid"
                              isShownForErrorCode:RTUploadVideoErrorInvalidVideoTitle
                                            field:RTUploadVideoViewFieldVideoTitle];
        });
    });
});

SpecEnd
