#import "RTTestCommon.h"

#import "RTRemoveVideoFromReelPresenter.h"

#import "RTRemoveVideoFromReelView.h"
#import "RTRemoveVideoFromReelInteractor.h"

#import "RTRemoveVideoFromReelError.h"
#import "RTErrorFactory.h"

SpecBegin(RTRemoveVideoFromReelPresenter)

describe(@"remove video from reel presenter", ^{
    
    __block RTRemoveVideoFromReelPresenter *presenter;
    
    __block id<RTRemoveVideoFromReelView> view;
    __block RTRemoveVideoFromReelInteractor *interactor;
    
    beforeEach(^{
        view  = mockProtocol(@protocol(RTRemoveVideoFromReelView));
        interactor = mock([RTRemoveVideoFromReelInteractor class]);
        
        presenter = [[RTRemoveVideoFromReelPresenter alloc] initWithView:view
                                                              interactor:interactor];
    });
    
    describe(@"requested video removal", ^{
        it(@"should invoke interactor", ^{
            [presenter requestedVideoRemovalFromReelForVideoId:@(videoId) reelId:@(reelId)];
            [verify(interactor) removeVideoWithVideoId:@(videoId) fromReelWithReelId:@(reelId)];
        });
    });
    
    describe(@"video removal succeeded", ^{
        it(@"should show video as being removed", ^{
            [presenter removeVideoFromReelSucceededForVideoId:@(videoId) reelId:@(reelId)];
            [verify(view) showVideoAsRemovedFromReelForVideoId:@(videoId) reelId:@(reelId)];
        });
    });
    
    describe(@"video removal failed", ^{
        it(@"video not found", ^{
            NSError *error = [RTErrorFactory removeVideoFromReelErrorWithCode:RTRemoveVideoFromReelErrorVideoNotFound];
            
            [presenter removeVideoFromReelFailedForVideoId:@(videoId) reelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"Cannot remove an unknown video!"];
        });
        
        it(@"reel not found", ^{
            NSError *error = [RTErrorFactory removeVideoFromReelErrorWithCode:RTRemoveVideoFromReelErrorReelNotFound];
            
            [presenter removeVideoFromReelFailedForVideoId:@(videoId) reelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"Cannot remove video from an unknown reel!"];
        });
        
        it(@"unauthorized", ^{
            NSError *error = [RTErrorFactory removeVideoFromReelErrorWithCode:RTRemoveVideoFromReelErrorUnauthorized];
            
            [presenter removeVideoFromReelFailedForVideoId:@(videoId) reelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"You do not have permission for that operation."];
        });
        
        it(@"unknown removal error", ^{
            NSError *error = [RTErrorFactory removeVideoFromReelErrorWithCode:RTRemoveVideoFromReelErrorUnknownError];
            
            [presenter removeVideoFromReelFailedForVideoId:@(videoId) reelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"Unknown error occurred while removing video from reel. Please try again."];
        });
    });
});

SpecEnd
