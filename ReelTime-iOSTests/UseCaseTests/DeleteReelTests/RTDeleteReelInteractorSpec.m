#import "RTTestCommon.h"

#import "RTDeleteReelInteractor.h"

#import "RTDeleteReelInteractorDelegate.h"
#import "RTDeleteReelDataManager.h"

#import "RTDeleteReelError.h"
#import "RTErrorFactory.h"

SpecBegin(RTDeleteReelInteractor)

describe(@"delete reel interactor", ^{
    
    __block RTDeleteReelInteractor *interactor;
    
    __block id<RTDeleteReelInteractorDelegate> delegate;
    __block RTDeleteReelDataManager *dataManager;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTDeleteReelInteractorDelegate));
        dataManager = mock([RTDeleteReelDataManager class]);
        
        interactor = [[RTDeleteReelInteractor alloc] initWithDelegate:delegate
                                                          dataManager:dataManager];
    });
    
    describe(@"deleting reel", ^{
        
        context(@"invalid reel id", ^{
            it(@"should treat invalid reel id as belonging to an unknown reel", ^{
                MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
                
                [interactor deleteReelWithReelId:nil];
                [verify(delegate) deleteReelFailedForReelId:nil withError:[captor capture]];
                
                expect(captor.value).to.beError(RTDeleteReelErrorDomain, RTDeleteReelErrorReelNotFound);
            });
        });
        
        context(@"valid reel id", ^{
            __block MKTArgumentCaptor *successCaptor;
            __block MKTArgumentCaptor *failureCaptor;
            
            beforeEach(^{
                successCaptor = [[MKTArgumentCaptor alloc] init];
                failureCaptor = [[MKTArgumentCaptor alloc] init];
                
                [interactor deleteReelWithReelId:@(reelId)];
                [verify(dataManager) deleteReelWithReelId:reelId
                                                  success:[successCaptor capture]
                                                  failure:[failureCaptor capture]];
            });
            
            it(@"should notify delegate of success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [verify(delegate) deleteReelSucceededForReelId:@(reelId)];
            });
            
            it(@"should notify delegate of failure", ^{
                NSError *error = [RTErrorFactory deleteReelErrorWithCode:RTDeleteReelErrorReelNotFound];
                
                ErrorCallback failureHandler = [failureCaptor value];
                failureHandler(error);
                
                [verify(delegate) deleteReelFailedForReelId:@(reelId) withError:error];
            });
        });
    });
});

SpecEnd
