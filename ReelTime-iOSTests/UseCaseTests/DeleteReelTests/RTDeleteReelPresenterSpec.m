#import "RTTestCommon.h"

#import "RTDeleteReelPresenter.h"

#import "RTDeleteReelView.h"
#import "RTDeleteReelInteractor.h"

#import "RTDeleteReelError.h"
#import "RTErrorFactory.h"

SpecBegin(RTDeleteReelPresenter)

describe(@"delete reel presenter", ^{

    __block RTDeleteReelPresenter *presenter;
    
    __block id<RTDeleteReelView> view;
    __block RTDeleteReelInteractor *interactor;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTDeleteReelView));
        interactor = mock([RTDeleteReelInteractor class]);
        
        presenter = [[RTDeleteReelPresenter alloc] initWithView:view
                                                     interactor:interactor];
    });
    
    describe(@"requested reel deletion", ^{
        it(@"should invoke interactor", ^{
            [presenter requestedReelDeletionForReelId:@(reelId)];
            [verify(interactor) deleteReelWithReelId:@(reelId)];
        });
    });
    
    describe(@"delete reel succeeded", ^{
        it(@"should show reel as being deleted", ^{
            [presenter deleteReelSucceededForReelId:@(reelId)];
            [verify(view) showReelAsDeletedForReelId:@(reelId)];
        });
    });
    
    describe(@"delete reel failed", ^{
        it(@"reel not found", ^{
            NSError *error = [RTErrorFactory deleteReelErrorWithCode:RTDeleteReelErrorReelNotFound];
            
            [presenter deleteReelFailedForReelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"Cannot delete an unknown reel!"];
        });

        it(@"unauthorized", ^{
            NSError *error = [RTErrorFactory deleteReelErrorWithCode:RTDeleteReelErrorUnauthorized];
            
            [presenter deleteReelFailedForReelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"You do not have permission for that operation."];
        });
        
        it(@"unknown delete error", ^{
            NSError *error = [RTErrorFactory deleteReelErrorWithCode:RTDeleteReelErrorUnknownError];
            
            [presenter deleteReelFailedForReelId:@(reelId) withError:error];
            [verify(view) showErrorMessage:@"Unknown error occurred while deleting reel. Please try again."];
        });
    });
});

SpecEnd
