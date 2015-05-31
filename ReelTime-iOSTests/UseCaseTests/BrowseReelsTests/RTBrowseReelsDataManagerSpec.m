#import "RTTestCommon.h"

#import "RTBrowseReelsDataManager.h"
#import "RTBrowseReelsDataManagerDelegate.h"
#import "RTAPIClient.h"

#import "RTReelList.h"
#import "RTReel.h"

SpecBegin(RTBrowseReelsDataManager)

describe(@"browse reels data manager", ^{
    
    __block RTBrowseReelsDataManager *dataManager;
    
    __block id<RTBrowseReelsDataManagerDelegate> delegate;
    __block RTAPIClient *client;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTBrowseReelsDataManagerDelegate));
        client = mock([RTAPIClient class]);
        dataManager = [[RTBrowseReelsDataManager alloc] initWithDelegate:delegate client:client];
    });
    
    describe(@"retrieving a reels list page", ^{
        __block BOOL callbackExecuted;
        __block NSArray *callbackReels;
        
        void (^callback)(NSArray *) = ^(NSArray *reels) {
            callbackExecuted = YES;
            callbackReels = reels;
        };
        
        beforeEach(^{
            callbackExecuted = NO;
            [dataManager retrievePage:pageNumber callback:callback];
        });
        
        it(@"should pass reels page to callback on success", ^{
            RTReel *reel = [[RTReel alloc] initWithReelId:@(133)
                                                     name:@"something"
                                             audienceSize:@(1)
                                           numberOfVideos:@(32)
                                                    owner:nil];

            RTReelList *reelList = [[RTReelList alloc] init];
            reelList.reels = @[reel];
            
            MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(delegate) listReelsPage:pageNumber
                                 withClient:client
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
            
            [verify(delegate) listReelsPage:pageNumber
                                 withClient:client
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