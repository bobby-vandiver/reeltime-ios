#import "RTTestCommon.h"

#import "RTDeleteVideoInteractor.h"

#import "RTDeleteVideoInteractorDelegate.h"
#import "RTDeleteVideoDataManager.h"

#import "RTDeleteVideoError.h"
#import "RTErrorFactory.h"

SpecBegin(RTDeleteVideoInteractor)

describe(@"delete video interactor", ^{
    
    __block RTDeleteVideoInteractor *interactor;
    
    __block id<RTDeleteVideoInteractorDelegate> delegate;
    __block RTDeleteVideoDataManager *dataManager;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTDeleteVideoInteractorDelegate));
        dataManager = mock([RTDeleteVideoDataManager class]);
        
        interactor = [[RTDeleteVideoInteractor alloc] initWithDelegate:delegate
                                                           dataManager:dataManager];
    });
    
    describe(@"deleting video", ^{
        
        context(@"invalid video id", ^{
            it(@"should treat invalid video id as belonging to an unknown video", ^{
                MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
                
                [interactor deleteVideoWithVideoId:nil];
                [verify(delegate) deleteVideoFailedForVideoId:nil withError:[captor capture]];
                
                expect(captor.value).to.beError(RTDeleteVideoErrorDomain, RTDeleteVideoErrorVideoNotFound);
            });
        });
    });
    
    context(@"valid video id", ^{
        __block MKTArgumentCaptor *successCaptor;
        __block MKTArgumentCaptor *failureCaptor;
        
        beforeEach(^{
            successCaptor = [[MKTArgumentCaptor alloc] init];
            failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [interactor deleteVideoWithVideoId:@(videoId)];
            [verify(dataManager) deleteVideoForVideoId:videoId
                                               success:[successCaptor capture]
                                               failure:[failureCaptor capture]];
        });
        
        it(@"should notify delegate of success", ^{
            NoArgsCallback successHandler = [successCaptor value];
            successHandler();
            [verify(delegate) deleteVideoSucceededForVideoId:@(videoId)];
        });
        
        it(@"should notify delegate of failure", ^{
            NSError *error = [RTErrorFactory deleteVideoErrorWithCode:RTDeleteVideoErrorVideoNotFound];
            
            ErrorCallback failureHandler = [failureCaptor value];
            failureHandler(error);
            
            [verify(delegate) deleteVideoFailedForVideoId:@(videoId) withError:error];
        });
    });
});

SpecEnd
