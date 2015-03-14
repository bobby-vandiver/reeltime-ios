#import "RTTestCommon.h"

#import "RTBrowseUsersDataManager.h"
#import "RTClient.h"

#import "RTUserList.h"
#import "RTUser.h"

SpecBegin(RTBrowseUsersDataManager)

describe(@"browse users data manager", ^{

    __block RTBrowseUsersDataManager *dataManager;
    
    __block RTClient *client;
    
    beforeEach(^{
        client = mock([RTClient class]);
        dataManager = [[RTBrowseUsersDataManager alloc] initWithClient:client];
    });
    
    describe(@"retrieving a users list page", ^{
        __block const NSUInteger page = 40;

        __block BOOL callbackExecuted;
        __block NSArray *callbackUsers;
        
        void (^callback)(NSArray *) = ^(NSArray *users) {
            callbackExecuted = YES;
            callbackUsers = users;
        };
        
        beforeEach(^{
            callbackExecuted = NO;
            [dataManager retrievePage:page callback:callback];
        });
        
        it(@"should pass users page to callback on success", ^{
            RTUser *user = [[RTUser alloc] initWithUsername:username
                                                displayName:displayName
                                          numberOfFollowers:@(12)
                                          numberOfFollowees:@(34)];
            
            RTUserList *userList = [[RTUserList alloc] init];
            userList.users = @[user];
            
            MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) listUsersPage:page
                                  success:[successCaptor capture]
                                  failure:anything()];
            
            expect(callbackExecuted).to.beFalsy();
            
            UserListCallback successHandler = [successCaptor value];
            successHandler(userList);
            
            expect(callbackExecuted).to.beTruthy();
            
            expect(callbackUsers).toNot.beNil();
            expect(callbackUsers).to.haveCountOf(1);
            
            expect(callbackUsers[0]).to.beUser(username, displayName, @(12), @(34));
        });
        
        it(@"should pass empty list to callback on failure", ^{
            MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) listUsersPage:page
                                  success:anything()
                                  failure:[failureCaptor capture]];
            
            expect(callbackExecuted).to.beFalsy();
            
            ServerErrorsCallback failureHandler = [failureCaptor value];
            failureHandler(nil);
            
            expect(callbackExecuted).to.beTruthy();
            
            expect(callbackUsers).toNot.beNil();
            expect(callbackUsers).to.haveCountOf(0);
        });
    });
});

SpecEnd
