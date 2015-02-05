#import "RTTestCommon.h"

#import "RTNewsfeedInteractor.h"
#import "RTNewsfeedInteractorDelegate.h"
#import "RTNewsfeedDataManager.h"

#import "RTNewsfeed.h"
#import "RTNewsfeedError.h"

SpecBegin(RTNewsfeedInteractor)

describe(@"newsfeed interactor", ^{
    
    __block RTNewsfeedInteractor *interactor;

    __block id<RTNewsfeedInteractorDelegate> delegate;
    __block RTNewsfeedDataManager *dataManager;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTNewsfeedInteractorDelegate));
        dataManager = mock([RTNewsfeedDataManager class]);
        
        interactor = [[RTNewsfeedInteractor alloc] initWithDelegate:delegate
                                                        dataManager:dataManager];
    });
    
    describe(@"successful newsfeed page retrieval", ^{
        const NSUInteger page = 23;
        
        it(@"should pass newsfeed to delegate", ^{
            [interactor newsfeedPage:page];
            
            MKTArgumentCaptor *callbackCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(dataManager) retrieveNewsfeedPage:page
                                             callback:[callbackCaptor capture]];

            RTNewsfeed *newsfeed;
            [verifyCount(delegate, never()) retrievedNewsfeed:newsfeed];
            
            void (^callback)(RTNewsfeed *) = [callbackCaptor value];
            callback(newsfeed);
            
            [verify(delegate) retrievedNewsfeed:newsfeed];
        });
    });
    
    describe(@"newsfeed page retrieval failure", ^{
        it(@"should not allow non-negative numbers", ^{
            const NSUInteger invalidPage = 0;
            [interactor newsfeedPage:invalidPage];
            
            MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
            [verify(delegate) failedToRetrieveNewsfeedWithError:[errorCaptor capture]];
            
            NSError *error = [errorCaptor value];
            expect(error).to.beError(RTNewsfeedErrorDomain, RTNewsfeedErrorInvalidPageNumber);
        });
    });
});

SpecEnd