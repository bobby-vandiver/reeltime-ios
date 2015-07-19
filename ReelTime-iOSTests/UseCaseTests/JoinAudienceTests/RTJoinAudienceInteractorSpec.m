#import "RTTestCommon.h"

#import "RTJoinAudienceInteractor.h"

#import "RTJoinAudienceInteractorDelegate.h"
#import "RTJoinAudienceDataManager.h"

#import "RTJoinAudienceError.h"
#import "RTErrorFactory.h"

SpecBegin(RTJoinAudienceInteractor)

describe(@"join audience interactor", ^{
    
    __block RTJoinAudienceInteractor *interactor;
    
    __block id<RTJoinAudienceInteractorDelegate> delegate;
    __block RTJoinAudienceDataManager *dataManager;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTJoinAudienceInteractorDelegate));
        dataManager = mock([RTJoinAudienceDataManager class]);
        
        interactor = [[RTJoinAudienceInteractor alloc] initWithDelegate:delegate
                                                            dataManager:dataManager];
    });
    
    describe(@"joining audience", ^{
        __block MKTArgumentCaptor *successCaptor;
        __block MKTArgumentCaptor *failureCaptor;
        
        beforeEach(^{
            successCaptor = [[MKTArgumentCaptor alloc] init];
            failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [interactor joinAudienceForReelId:@(reelId)];
            [verify(dataManager) requestAudienceMembershipForReelId:@(reelId)
                                                        joinSuccess:[successCaptor capture]
                                                        joinFailure:[failureCaptor capture]];
        });
        
        it(@"should notify delegate of success", ^{
            NoArgsCallback successHandler = [successCaptor value];
            successHandler();
            [verify(delegate) joinAudienceSucceedForReelId:@(reelId)];
        });
        
        it(@"should notify delegate of failure", ^{
            NSError *error = [RTErrorFactory joinAudienceErrorWithCode:RTJoinAudienceErrorReelNotFound];
            
            ErrorCallback failureHandler = [failureCaptor value];
            failureHandler(error);
            
            [verify(delegate) joinAudienceFailedForReelId:@(reelId) withError:error];
        });
    });
});

SpecEnd
