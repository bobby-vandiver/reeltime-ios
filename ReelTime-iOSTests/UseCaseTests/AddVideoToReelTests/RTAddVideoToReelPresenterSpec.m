#import "RTTestCommon.h"

#import "RTAddVideoToReelPresenter.h"

#import "RTAddVideoToReelView.h"
#import "RTAddVideoToReelInteractor.h"

#import "RTAddVideoToReelError.h"
#import "RTErrorFactory.h"

SpecBegin(RTAddVideoToReelPresenter)

describe(@"add video to reel presenter", ^{
    
    __block RTAddVideoToReelPresenter *presenter;
    
    __block id<RTAddVideoToReelView> view;
    __block RTAddVideoToReelInteractor *interactor;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTAddVideoToReelView));
        interactor = mock([RTAddVideoToReelInteractor class]);
        
        presenter = [[RTAddVideoToReelPresenter alloc] initWithView:view
                                                         interactor:interactor];
    });
    
    describe(@"requested video addition to reel", ^{
        it(@"should invoke interactor", ^{
            [presenter requestedVideoAdditionForVideoId:@(videoId) toReelForReelId:@(reelId)];
            [verify(interactor) addVideoWithVideoId:@(videoId) toReelWithReelId:@(reelId)];
        });
    });
    
    describe(@"video addition succeeded", ^{
        it(@"should show video as being added to reel", ^{
            [presenter addVideoToReelSucceededForVideoId:@(videoId) reelId:@(reelId)];
            [verify(view) showVideoAsAddedToReelForVideoId:@(videoId) reelId:@(reelId)];
        });
    });
    
    describe(@"video addition failed", ^{
        it(@"video not found", ^{
            NSError *error = [RTErrorFactory addVideoToReelErrorWithCode:RTAddVideoToReelErrorVideoNotFound];
            
            [presenter addVideoToReelFailedForVideoId:@(videoId) reelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"Cannot add an unknown video to a reel!"];
        });
        
        it(@"reel not found", ^{
            NSError *error = [RTErrorFactory addVideoToReelErrorWithCode:RTAddVideoToReelErrorReelNotFound];
            
            [presenter addVideoToReelFailedForVideoId:@(videoId) reelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"Cannot add a video to an unknown reel!"];
        });
        
        it(@"unauthorized operation", ^{
            NSError *error = [RTErrorFactory addVideoToReelErrorWithCode:RTAddVideoToReelErrorUnauthorized];
            
            [presenter addVideoToReelFailedForVideoId:@(videoId) reelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"You don't have permission to do that!"];
        });
        
        it(@"unknown add to reel error", ^{
            NSError *error = [RTErrorFactory addVideoToReelErrorWithCode:RTAddVideoToReelErrorUnknownError];
            
            [presenter addVideoToReelFailedForVideoId:@(videoId) reelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"Unknown error occurred while adding the video to the reel. Please try again."];
        });
        
        // TODO
        xit(@"general unknown error", ^{
            NSError *error = [NSError errorWithDomain:@"unknown" code:1 userInfo:nil];

            [presenter addVideoToReelFailedForVideoId:@(videoId) reelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"Unknown error occurred while adding the video to the reel. Please try again."];
        });
    });
});

SpecEnd
