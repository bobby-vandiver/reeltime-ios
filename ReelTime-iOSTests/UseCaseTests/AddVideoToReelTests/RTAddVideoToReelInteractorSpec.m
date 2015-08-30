#import "RTTestCommon.h"

#import "RTAddVideoToReelInteractor.h"

#import "RTAddVideoToReelInteractorDelegate.h"
#import "RTAddVideoToReelDataManager.h"

#import "RTAddVideoToReelError.h"
#import "RTErrorFactory.h"

SpecBegin(RTAddVideoToReelInteractor)

describe(@"add video to reel interactor", ^{
    
    __block RTAddVideoToReelInteractor *interactor;
    
    __block id<RTAddVideoToReelInteractorDelegate> delegate;
    __block RTAddVideoToReelDataManager *dataManager;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTAddVideoToReelInteractorDelegate));
        dataManager = mock([RTAddVideoToReelDataManager class]);
        
        interactor = [[RTAddVideoToReelInteractor alloc] initWithDelegate:delegate
                                                              dataManager:dataManager];
    });
    
    describe(@"adding video to reel", ^{
        
        context(@"invalid parameters", ^{
            __block MKTArgumentCaptor *captor;
            
            beforeEach(^{
                captor = [[MKTArgumentCaptor alloc] init];
            });

            it(@"should treat invalid video id as belonging to an unknown video", ^{
                [interactor addVideoWithVideoId:nil toReelWithReelId:@(reelId)];
                [verify(delegate) addVideoToReelFailedForVideoId:nil reelId:@(reelId) withError:[captor capture]];
                
                expect(captor.value).to.beError(RTAddVideoToReelErrorDomain, RTAddVideoToReelErrorVideoNotFound);
            });
            
            it(@"should treat invalid reel id as belonging to an unknown reel", ^{
                [interactor addVideoWithVideoId:@(videoId) toReelWithReelId:nil];
                [verify(delegate) addVideoToReelFailedForVideoId:@(videoId) reelId:nil withError:[captor capture]];
                
                expect(captor.value).to.beError(RTAddVideoToReelErrorDomain, RTAddVideoToReelErrorReelNotFound);
            });
        });
        
        context(@"valid parameters", ^{
            __block MKTArgumentCaptor *successCaptor;
            __block MKTArgumentCaptor *failureCaptor;
            
            beforeEach(^{
                successCaptor = [[MKTArgumentCaptor alloc] init];
                failureCaptor = [[MKTArgumentCaptor alloc] init];
                
                [interactor addVideoWithVideoId:@(videoId) toReelWithReelId:@(reelId)];
                [verify(dataManager) addVideoForVideoId:videoId
                                        toReelForReelId:reelId
                                                success:[successCaptor capture]
                                                failure:[failureCaptor capture]];
            });
            
            it(@"should notify delegate of success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [verify(delegate) addVideoToReelSucceededForVideoId:@(videoId) reelId:@(reelId)];
            });
            
            it(@"should notify delegate of failure", ^{
                NSError *error = [RTErrorFactory addVideoToReelErrorWithCode:RTAddVideoToReelErrorVideoNotFound];
                
                ErrorCallback failureHandler = [failureCaptor value];
                failureHandler(error);
                
                [verify(delegate) addVideoToReelFailedForVideoId:@(videoId) reelId:@(reelId) withError:error];
            });
        });
    });
});

SpecEnd
