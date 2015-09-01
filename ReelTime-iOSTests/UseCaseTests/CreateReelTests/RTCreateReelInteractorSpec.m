#import "RTTestCommon.h"

#import "RTCreateReelInteractor.h"

#import "RTCreateReelInteractorDelegate.h"
#import "RTCreateReelDataManager.h"

#import "RTCreateReelError.h"
#import "RTErrorFactory.h"

SpecBegin(RTCreateReelInteractor)

describe(@"create reel interactor", ^{
    
    __block RTCreateReelInteractor *interactor;
    
    __block id<RTCreateReelInteractorDelegate> delegate;
    __block RTCreateReelDataManager *dataManager;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTCreateReelInteractorDelegate));
        dataManager = mock([RTCreateReelDataManager class]);
        
        interactor = [[RTCreateReelInteractor alloc] initWithDelegate:delegate
                                                          dataManager:dataManager];
    });
    
    describe(@"creating reel", ^{
        
        context(@"invalid name", ^{
            __block MKTArgumentCaptor *captor;
            
            beforeEach(^{
                captor = [[MKTArgumentCaptor alloc] init];
            });

            it(@"blank", ^{
                [interactor createReelWithName:BLANK];
                [verify(delegate) createReelFailedForName:BLANK withError:[captor capture]];

                expect(captor.value).to.beError(RTCreateReelErrorDomain, RTCreateReelErrorMissingReelName);
            });
            
            it(@"nil", ^{
                [interactor createReelWithName:nil];
                [verify(delegate) createReelFailedForName:nil withError:[captor capture]];
                
                expect(captor.value).to.beError(RTCreateReelErrorDomain, RTCreateReelErrorMissingReelName);
            });
            
            it(@"too short", ^{
                [interactor createReelWithName:@"ab"];
                [verify(delegate)createReelFailedForName:@"ab" withError:[captor capture]];
                
                expect(captor.value).to.beError(RTCreateReelErrorDomain, RTCreateReelErrorInvalidReelName);
            });
            
            it(@"too long", ^{
                [interactor createReelWithName:@"abcdefghijklmnopqrstuvwxyz"];
                [verify(delegate) createReelFailedForName:@"abcdefghijklmnopqrstuvwxyz" withError:[captor capture]];
                
                expect(captor.value).to.beError(RTCreateReelErrorDomain, RTCreateReelErrorInvalidReelName);
            });
        });
        
        context(@"valid name", ^{
            __block MKTArgumentCaptor *successCaptor;
            __block MKTArgumentCaptor *failureCaptor;
            
            beforeEach(^{
                successCaptor = [[MKTArgumentCaptor alloc] init];
                failureCaptor = [[MKTArgumentCaptor alloc] init];
                
                [interactor createReelWithName:reelName];
                [verify(dataManager) createReelForName:reelName
                                               success:[successCaptor capture]
                                               failure:[failureCaptor capture]];
            });
            
            it(@"should notify delegate of success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [verify(delegate) createReelSucceededForName:reelName];
            });
            
            it(@"should notify delegate of failure", ^{
                NSError *error = [RTErrorFactory createReelErrorWithCode:RTCreateReelErrorInvalidReelName];
                
                ErrorCallback failureHandler = [failureCaptor value];
                failureHandler(error);
                
                [verify(delegate) createReelFailedForName:reelName withError:error];
            });
        });
    });
});

SpecEnd
