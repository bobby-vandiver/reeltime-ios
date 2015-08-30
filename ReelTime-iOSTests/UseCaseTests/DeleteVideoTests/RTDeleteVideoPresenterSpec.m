#import "RTTestCommon.h"

#import "RTDeleteVideoPresenter.h"

#import "RTDeleteVideoView.h"
#import "RTDeleteVideoInteractor.h"

#import "RTDeleteVideoError.h"
#import "RTErrorFactory.h"

SpecBegin(RTDeleteVideoPresenter)

describe(@"delete video presenter", ^{
    
    __block RTDeleteVideoPresenter *presenter;
    
    __block id<RTDeleteVideoView> view;
    __block RTDeleteVideoInteractor *interactor;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTDeleteVideoView));
        interactor = mock([RTDeleteVideoInteractor class]);
        
        presenter = [[RTDeleteVideoPresenter alloc] initWithView:view
                                                      interactor:interactor];
    });
    
    describe(@"requested video deletion", ^{
        it(@"should invoke interactor", ^{
            [presenter requestedVideoDeletionForVideoId:@(videoId)];
            [verify(interactor) deleteVideoWithVideoId:@(videoId)];
        });
    });
    
    describe(@"delete video succeeded", ^{
        it(@"should show video as being deleted", ^{
            [presenter deleteVideoSucceededForVideoId:@(videoId)];
            [verify(view) showVideoAsDeletedForVideoId:@(videoId)];
        });
    });
    
    describe(@"delete video failed", ^{
        it(@"video not found", ^{
            NSError *error = [RTErrorFactory deleteVideoErrorWithCode:RTDeleteVideoErrorVideoNotFound];
            
            [presenter deleteVideoFailedForVideoId:@(videoId) withError:error];
            [verify(view) showErrorMessage:@"Cannot delete an unknown video!"];
        });
        
        it(@"unknown delete error", ^{
            NSError *error = [RTErrorFactory deleteVideoErrorWithCode:RTDeleteVideoErrorUnknownError];
            
            [presenter deleteVideoFailedForVideoId:@(videoId) withError:error];
            [verify(view) showErrorMessage:@"Unknown error occurred while deleting video. Please try again."];
        });
        
        it(@"general unknown error", ^{
            NSError *error = [NSError errorWithDomain:@"unknown" code:1 userInfo:nil];
            
            [presenter deleteVideoFailedForVideoId:@(videoId) withError:error];
            [verify(view) showErrorMessage:@"Unknown error occurred while deleting video. Please try again."];
        });
    });
});

SpecEnd
