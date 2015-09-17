#import "RTTestCommon.h"

#import "RTRemoveVideoFromReelInteractor.h"

#import "RTRemoveVideoFromReelInteractorDelegate.h"
#import "RTRemoveVideoFromReelDataManager.h"

#import "RTRemoveVideoFromReelError.h"
#import "RTErrorFactory.h"

SpecBegin(RTRemoveVideoFromReelInteractor)

describe(@"remove video from reel interactor", ^{
    
    __block RTRemoveVideoFromReelInteractor *interactor;
    
    __block id<RTRemoveVideoFromReelInteractorDelegate> delegate;
    __block RTRemoveVideoFromReelDataManager *dataManager;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTRemoveVideoFromReelInteractorDelegate));
        dataManager = mock([RTRemoveVideoFromReelDataManager class]);
        
        interactor = [[RTRemoveVideoFromReelInteractor alloc] initWithDelegate:delegate
                                                                   dataManager:dataManager];
    });
    
    describe(@"removing video from reel", ^{
        
        context(@"invalid arguments", ^{
            it(@"should treat invalid video id as belonging to an unknown video", ^{
                MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
                
                [interactor removeVideoWithVideoId:nil fromReelWithReelId:@(reelId)];
                [verify(delegate) removeVideoFromReelFailedForVideoId:nil reelId:@(reelId) withError:[captor capture]];
                
                expect(captor.value).to.beError(RTRemoveVideoFromReelErrorDomain, RTRemoveVideoFromReelErrorVideoNotFound);
            });
            
            it(@"should treat invalid reel id as belonging to an unknown reel", ^{
                MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
                
                [interactor removeVideoWithVideoId:@(videoId) fromReelWithReelId:nil];
                [verify(delegate) removeVideoFromReelFailedForVideoId:@(videoId) reelId:nil withError:[captor capture]];
                
                expect(captor.value).to.beError(RTRemoveVideoFromReelErrorDomain, RTRemoveVideoFromReelErrorReelNotFound);
            });
        });
        
        context(@"valid arguments", ^{
            __block MKTArgumentCaptor *successCaptor;
            __block MKTArgumentCaptor *failureCaptor;
            
            beforeEach(^{
                successCaptor = [[MKTArgumentCaptor alloc] init];
                failureCaptor = [[MKTArgumentCaptor alloc] init];
                
                [interactor removeVideoWithVideoId:@(videoId) fromReelWithReelId:@(reelId)];
                [verify(dataManager) removeVideoForVideoId:videoId
                                         fromReelForReelId:reelId
                                                   success:[successCaptor capture]
                                                   failure:[failureCaptor capture]];
            });
            
            it(@"should notify delegate of success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [verify(delegate) removeVideoFromReelSucceededForVideoId:@(videoId) reelId:@(reelId)];
            });
            
            it(@"should notify delegate of failure", ^{
                NSError *error = [RTErrorFactory removeVideoFromReelErrorWithCode:RTRemoveVideoFromReelErrorVideoNotFound];
                
                ErrorCallback failureHandler = [failureCaptor value];
                failureHandler(error);
                
                [verify(delegate) removeVideoFromReelFailedForVideoId:@(videoId) reelId:@(reelId) withError:error];
            });
        });
    });
});

SpecEnd
