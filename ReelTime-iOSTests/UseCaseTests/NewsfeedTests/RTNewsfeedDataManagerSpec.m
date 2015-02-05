#import "RTTestCommon.h"

#import "RTNewsfeedDataManager.h"

#import "RTClient.h"
#import "RTNewsfeed.h"

SpecBegin(RTNewsfeedDataManager)

describe(@"newsfeed data manager", ^{
    
    __block RTNewsfeedDataManager *dataManager;
    
    __block RTClient *client;
    
    beforeEach(^{
        client = mock([RTClient class]);
        dataManager = [[RTNewsfeedDataManager alloc] initWithClient:client];
    });
    
    describe(@"retrieving a newsfeed page", ^{
        __block const NSUInteger page = 24;
        __block BOOL callbackExecuted;
        
        __block RTNewsfeed *callbackNewsfeed;
        
        void (^callback)(RTNewsfeed *) = ^(RTNewsfeed *newsfeed) {
            callbackNewsfeed = newsfeed;
            callbackExecuted = YES;
        };
        
        beforeEach(^{
            callbackExecuted = NO;

            [dataManager retrieveNewsfeedPage:page callback:callback];
        });
        
        it(@"should pass newsfeed page to callback on success", ^{
            MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) newsfeedPage:page
                                 success:[successCaptor capture]
                                 failure:anything()];
            
            expect(callbackExecuted).to.beFalsy();
            
            void (^successHandler)(RTNewsfeed *) = [successCaptor value];
            successHandler(nil);
            
            expect(callbackExecuted).to.beTruthy();
        });
        
        it(@"should pass newsfeed with no activites to callback on failure", ^{
            MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) newsfeedPage:page
                                 success:anything()
                                 failure:[failureCaptor capture]];
            
            expect(callbackExecuted).to.beFalsy();
            
            void (^failureHandler)(RTServerErrors *) = [failureCaptor value];
            failureHandler(nil);
            
            expect(callbackExecuted).to.beTruthy();
            
            expect(callbackNewsfeed.activities).toNot.beNil();
            expect(callbackNewsfeed.activities.count).to.equal(0);
        });
    });
});

SpecEnd
