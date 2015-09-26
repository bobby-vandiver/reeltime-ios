#import "RTClientSpecCallbackExpectation.h"
#import "RTTestCommon.h"

#import "RTServerErrors.h"
#import "RTClientCredentials.h"

#import "RTClient.h"
#import "RTClientList.h"

#import "RTUser.h"
#import "RTUserList.h"

#import "RTReel.h"
#import "RTReelList.h"

#import "RTVideo.h"
#import "RTVideoList.h"

NSString *const BAD_REQUEST_ERROR_MESSAGE = @"Bad Request";
NSString *const NOT_FOUND_ERROR_MESSAGE = @"Not Found";
NSString *const FORBIDDEN_ERROR_MESSAGE = @"Forbidden";
NSString *const SERVICE_UNAVAILABLE_ERROR_MESSAGE = @"Service Unavailable";

NSString *const BAD_REQUEST_WITH_ERRORS_FILENAME = @"bad-request-with-errors";
NSString *const NOT_FOUND_WITH_ERRORS_FILENAME = @"not-found-with-errors";
NSString *const FORBIDDEN_WITH_ERRORS_FILENAME = @"forbidden-with-errors";

NSString *const SERVER_INTERNAL_ERROR_FILENAME = @"server-internal-error";
NSString *const SERVICE_UNAVAILABLE_WITH_ERRORS_FILENAME = @"service-unavailable-with-errors";

NSString *const SUCCESSFUL_CREATED_CLIENT_CREDENTIALS_FILENAME = @"successful-created-client-credentials";
NSString *const SUCCESSFUL_CREATED_WITH_NO_BODY_FILENAME = @"successful-created-with-no-body";
NSString *const SUCCESSFUL_OK_WITH_NO_BODY_FILENAME = @"successful-ok-with-no-body";

NSString *const SUCCESSFUL_OK_WITH_CLIENTS_LIST_EMPTY = @"client-list-no-clients";
NSString *const SUCCESSFUL_OK_WITH_CLIENTS_LIST_ONE_CLIENT = @"client-list-one-client";
NSString *const SUCCESSFUL_OK_WITH_CLIENTS_LIST_MULTIPLE_CLIENTS = @"client-list-multiple-clients";

NSString *const SUCCESSFUL_OK_WITH_REELS_LIST_EMPTY = @"reel-list-no-reels";
NSString *const SUCCESSFUL_OK_WITH_REELS_LIST_ONE_REEL = @"reel-list-one-reel";
NSString *const SUCCESSFUL_OK_WITH_REELS_LIST_MULTIPLE_REELS = @"reel-list-multiple-reels";

NSString *const SUCCESSFUL_OK_WITH_USERS_LIST_EMPTY = @"user-list-no-users";
NSString *const SUCCESSFUL_OK_WITH_USERS_LIST_ONE_USER = @"user-list-one-user";
NSString *const SUCCESSFUL_OK_WITH_USERS_LIST_MULTIPLE_USERS = @"user-list-multiple-users";

NSString *const SUCCESSFUL_OK_WITH_VIDEOS_LIST_EMPTY = @"video-list-no-videos";
NSString *const SUCCESSFUL_OK_WITH_VIDEOS_LIST_ONE_VIDEO = @"video-list-one-video";
NSString *const SUCCESSFUL_OK_WITH_VIDEOS_LIST_MULTIPLE_VIDEOS = @"video-list-multiple-videos";

NSString *const TOKEN_ERROR_BAD_CLIENT_CREDENTIALS_FILENAME = @"token-bad-client-credentials";
NSString *const TOKEN_ERROR_BAD_CLIENT_CREDENTIALS_ERROR_CODE = @"invalid_client";
NSString *const TOKEN_ERROR_BAD_CLIENT_CREDENTIALS_ERROR_DESCRIPTION = @"Bad client credentials";

NSString *const TOKEN_ERROR_BAD_USER_CREDENTIALS_FILENAME = @"token-bad-user-credentials";
NSString *const TOKEN_ERROR_BAD_USER_CREDENTIALS_ERROR_CODE = @"invalid_grant";
NSString *const TOKEN_ERROR_BAD_USER_CREDENTIALS_ERROR_DESCRIPTION = @"Bad credentials";

NSString *const SUCCESSFUL_TOKEN_FILENAME = @"token-successful";
NSString *const SUCCESSFUL_TOKEN_TOKEN_TYPE = @"bearer";
NSString *const SUCCESSFUL_TOKEN_ACCESS_TOKEN = @"940a0300-ddd7-4302-873c-815a2a6b87ac";
NSString *const SUCCESSFUL_TOKEN_REFRESH_TOKEN = @"cb9f2c52-3e74-4bd7-9327-ba29bd31cb13";
NSString *const SUCCESSFUL_TOKEN_SCOPE = @"reels-read audiences-read videos-write users-write videos-read audiences-write users-read reels-write";
const NSInteger SUCCESSFUL_TOKEN_EXPIRES_IN = 43163;

@implementation RTClientSpecCallbackExpectation

- (void (^)(DoneCallback))shouldNotExecute {
    return ^(DoneCallback done) {
        failure(@"Executed an unexpected callback");
        done();
    };
}

- (SuccessCallback (^)(DoneCallback))shouldExecuteSuccessCallback {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            done();
        };
    };
}

- (SuccessCallback (^)(DoneCallback))shouldNotExecuteSuccessCallback {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            self.shouldNotExecute(done);
        };
    };
}

- (FailureCallback (^)(DoneCallback))shouldNotExecuteFailureCallback {
    return ^FailureCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTServerErrors class]);
            self.shouldNotExecute(done);
        };
    };
}

- (FailureCallback (^)(NSString *, DoneCallback))shouldExecuteFailureCallbackWithMessage {
    return ^FailureCallback(NSString *expectedError, DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTServerErrors class]);
            
            RTServerErrors *serverErrors = (RTServerErrors *)obj;
            expect(serverErrors.errors).to.haveCountOf(1);
            expect(serverErrors.errors).to.contain(expectedError);
            
            done();
        };
    };
}

- (SuccessCallback (^)(DoneCallback))shouldReceiveClientCredentialsInSuccessfulResponse {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTClientCredentials class]);
            
            RTClientCredentials *clientCredentials = (RTClientCredentials *)obj;
            expect(clientCredentials.clientId).to.equal(@"5bdee758-cf71-4cd5-9bd9-aded45ce9964");
            expect(clientCredentials.clientSecret).to.equal(@"g70mC9ZbpKa6p6R1tJPVWTm55BWHnSkmCv27F=oSI6");
            
            done();
        };
    };
}

- (SuccessCallback (^)(DoneCallback))shouldReceiveEmptyClientListInSuccessfulResponse {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTClientList class]);
            
            RTClientList *clientList = (RTClientList *)obj;
            expect(clientList.clients).to.haveACountOf(0);
            
            done();
        };
    };
}

- (SuccessCallback (^)(DoneCallback))shouldReceiveClientListWithOneClientInSuccessfulResponse {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTClientList class]);
            
            RTClientList *clientList = (RTClientList *)obj;
            expect(clientList.clients).to.haveACountOf(1);
            
            RTClient *first = clientList.clients[0];
            expect(first.clientId).to.equal(@"cid1");
            expect(first.clientName).to.equal(@"cname1");
            
            done();
        };
    };
}

- (SuccessCallback (^)(DoneCallback))shouldReceiveClientListWithMultipleClientsInSuccessfulResponse {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTClientList class]);
            
            RTClientList *clientList = (RTClientList *)obj;
            expect(clientList.clients).to.haveACountOf(2);
            
            RTClient *first = clientList.clients[0];
            expect(first.clientId).to.equal(@"cid1");
            expect(first.clientName).to.equal(@"cname1");
            
            RTClient *second = clientList.clients[1];
            expect(second.clientId).to.equal(@"cid2");
            expect(second.clientName).to.equal(@"cname2");
            
            done();
        };
    };
}

- (SuccessCallback (^)(DoneCallback))shouldReceiveEmptyReelListInSuccessfulResponse {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTReelList class]);
            
            RTReelList *reelList = (RTReelList *)obj;
            expect(reelList.reels).to.haveCountOf(0);
            
            done();
        };
    };
}

- (SuccessCallback (^)(DoneCallback))shouldReceiveReelListWithOneReelInSuccessfulResponse {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTReelList class]);
            
            RTReelList *reelList = (RTReelList *)obj;
            expect(reelList.reels).to.haveCountOf(1);
            
            RTReel *first = reelList.reels[0];
            expect(first).to.beReel(@(759), @"some reel", @(0), @(1), @(YES));
            
            done();
        };
    };
}

- (SuccessCallback (^)(DoneCallback))shouldReceiveReelListWithMultipleReelsInSuccessfulResponse {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTReelList class]);
            
            RTReelList *reelList = (RTReelList *)obj;
            expect(reelList.reels).to.haveCountOf(2);
            
            RTReel *first = reelList.reels[0];
            expect(first).to.beReel(@(759), @"some reel", @(0), @(1), @(YES));
            
            RTReel *second = reelList.reels[1];
            expect(second).to.beReel(@(758), @"any reel", @(41), @(30), @(YES));
            
            done();
        };
    };
}

- (SuccessCallback (^)(DoneCallback))shouldReceiveEmptyUserListInSuccessfulResponse {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTUserList class]);
            
            RTUserList *userList = (RTUserList *)obj;
            expect(userList.users).to.haveCountOf(0);
            
            done();
        };
    };
}

- (SuccessCallback (^)(DoneCallback))shouldReceiveUserListWithOneUserInSuccessfulResponse {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTUserList class]);
            
            RTUserList *userList = (RTUserList *)obj;
            expect(userList.users).to.haveCountOf(1);
            
            RTUser *first = userList.users[0];
            expect(first).to.beUser(@"first", @"the first", @(31), @(941), @(52), @(27), @(YES));
            
            done();
        };
    };
}

- (SuccessCallback (^)(DoneCallback))shouldReceiveUserListWithMultipleUsersInSuccessfulResponse {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTUserList class]);
            
            RTUserList *userList = (RTUserList *)obj;
            expect(userList.users).to.haveCountOf(2);
            
            RTUser *first = userList.users[0];
            expect(first).to.beUser(@"first", @"the first", @(31), @(941), @(52), @(27), @(YES));
            
            RTUser *second = userList.users[1];
            expect(second).to.beUser(@"second", @"the second", @(74), @(4019), @(510), @(213), @(YES));
            
            done();
        };
    };
}

- (SuccessCallback (^)(DoneCallback))shouldReceiveEmptyVideoListInSuccessfulResponse {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTVideoList class]);
            
            RTVideoList *videoList = (RTVideoList *)obj;
            expect(videoList.videos).to.haveCountOf(0);
            
            done();
        };
    };
}

- (SuccessCallback (^)(DoneCallback))shouldReceiveVideoListWithOneVideoInSuccessfulResponse {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTVideoList class]);
            
            RTVideoList *videoList = (RTVideoList *)obj;
            expect(videoList.videos).to.haveCountOf(1);
            
            RTVideo *first = videoList.videos[0];
            expect(first).to.beVideo(@(591), @"first video");
            
            done();
        };
    };
}

- (SuccessCallback (^)(DoneCallback))shouldReceiveVideoListWithMultipleVideosInSuccessfulResponse {
    return ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTVideoList class]);
            
            RTVideoList *videoList = (RTVideoList *)obj;
            expect(videoList.videos).to.haveCountOf(2);
            
            RTVideo *first = videoList.videos[0];
            expect(first).to.beVideo(@(591), @"first video");
            
            RTVideo *second = videoList.videos[1];
            expect(second).to.beVideo(@(8174), @"second video");
            
            done();
        };
    };
}

@end
