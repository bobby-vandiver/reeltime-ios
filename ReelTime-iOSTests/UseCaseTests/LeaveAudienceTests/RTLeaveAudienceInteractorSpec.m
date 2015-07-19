#import "RTTestCommon.h"

#import "RTLeaveAudienceInteractor.h"

#import "RTLeaveAudienceInteractorDelegate.h"
#import "RTLeaveAudienceDataManager.h"

#import "RTLeaveAudienceError.h"
#import "RTErrorFactory.h"

SpecBegin(RTLeaveAudienceInteractor)

describe(@"leave audience interactor", ^{
    
    __block RTLeaveAudienceInteractor *interactor;
    
    __block id<RTLeaveAudienceInteractorDelegate> delegate;
    __block RTLeaveAudienceDataManager *dataManager;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTLeaveAudienceInteractorDelegate));
        dataManager = mock([RTLeaveAudienceDataManager class]);
        
        interactor = [[RTLeaveAudienceInteractor alloc] initWithDelegate:delegate
                                                             dataManager:dataManager];
    });
    
    describe(@"leaving audience", ^{
        
        context(@"invalid reel id", ^{
            it(@"should treat invalid reel id as an unknown reel", ^{
                MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
                
                [interactor leaveAudienceForReelId:nil];
                [verify(delegate) leaveAudienceFailedForReelId:nil withError:[captor capture]];
                
                expect(captor.value).to.beError(RTLeaveAudienceErrorDomain, RTLeaveAudienceErrorReelNotFound);
            });
        });
        
        context(@"valid reel id", ^{
            __block MKTArgumentCaptor *successCaptor;
            __block MKTArgumentCaptor *failureCaptor;
            
            beforeEach(^{
                successCaptor = [[MKTArgumentCaptor alloc] init];
                failureCaptor = [[MKTArgumentCaptor alloc] init];
                
                [interactor leaveAudienceForReelId:@(reelId)];
                [verify(dataManager) requestAudienceLeaveForReelId:@(reelId)
                                                      leaveSuccess:[successCaptor capture]
                                                      leaveFailure:[failureCaptor capture]];
            });
            
            it(@"should notify delegate of success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [verify(delegate) leaveAudienceSucceededForReelId:@(reelId)];
            });
            
            it(@"should notify delegate of failure", ^{
                NSError *error = [RTErrorFactory leaveAudienceErrorWithCode:RTLeaveAudienceErrorReelNotFound];
                
                ErrorCallback failureHandler = [failureCaptor value];
                failureHandler(error);
                
                [verify(delegate) leaveAudienceFailedForReelId:@(reelId) withError:error];
            });
        });
    });
});

SpecEnd
