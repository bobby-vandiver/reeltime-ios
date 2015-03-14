#import "RTTestCommon.h"

#import "RTBrowseReelsDataManager.h"
#import "RTClient.h"

#import "RTReelList.h"
#import "RTReel.h"

SpecBegin(RTBrowseReelsDataManager)

describe(@"browse reels data manager", ^{
    
    __block RTBrowseReelsDataManager *dataManager;
    
    __block RTClient *client;
    
    beforeEach(^{
        client = mock([RTClient class]);
        dataManager = [[RTBrowseReelsDataManager alloc] initWithClient:client];
    });
    
    describe(@"retrieving a reels list page", ^{
        __block const NSUInteger page = 95;
        
        __block BOOL callbackExecuted;
        __block NSArray *callbackReels;
        
        void (^callback)(NSArray *) = ^(NSArray *reels) {
            callbackExecuted = YES;
            callbackReels = reels;
        };
        
        beforeEach(^{
            callbackExecuted = NO;
            [dataManager retrievePage:page callback:callback];
        });
        
        it(@"should pass reels page to callback on success", ^{
            RTReel *reel = [[RTReel alloc] initWithReelId:@(133)
                                                     name:@"something"
                                             audienceSize:@(1)
                                           numberOfVideos:@(32)];

            RTReelList *reelList = [[RTReelList alloc] init];
            reelList.reels = @[reel];
            
            MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) listReelsPage:page
                                  success:[successCaptor capture]
                                  failure:anything()];
            
            expect(callbackExecuted).to.beFalsy();
            
            ReelListCallback successHandler = [successCaptor value];
            successHandler(reelList);
            
            expect(callbackExecuted).to.beTruthy();
            
            expect(callbackReels).toNot.beNil();
            expect(callbackReels).to.haveCountOf(1);
            
            expect(callbackReels[0]).to.beReel(@(133), @"something", @(1), @(32));
        });
        
        it(@"should pass empty list to callback on failure", ^{
            MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) listReelsPage:page
                                  success:anything()
                                  failure:[failureCaptor capture]];
            
            expect(callbackExecuted).to.beFalsy();
            
            ServerErrorsCallback failureHandler = [failureCaptor value];
            failureHandler(nil);
            
            expect(callbackExecuted).to.beTruthy();
            
            expect(callbackReels).toNot.beNil();
            expect(callbackReels).to.haveCountOf(0);
        });
    });
});

SpecEnd