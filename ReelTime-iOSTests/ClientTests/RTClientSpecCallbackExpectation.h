#import <Foundation/Foundation.h>

#import "RTAuthenticationAwareHTTPClient.h"
#import <Specta/SpectaDSL.h>

extern NSString *const BAD_REQUEST_ERROR_MESSAGE;
extern NSString *const NOT_FOUND_ERROR_MESSAGE;
extern NSString *const FORBIDDEN_ERROR_MESSAGE;
extern NSString *const SERVICE_UNAVAILABLE_ERROR_MESSAGE;

extern NSString *const BAD_REQUEST_WITH_ERRORS_FILENAME;
extern NSString *const NOT_FOUND_WITH_ERRORS_FILENAME;
extern NSString *const FORBIDDEN_WITH_ERRORS_FILENAME;

extern NSString *const SERVER_INTERNAL_ERROR_FILENAME;
extern NSString *const SERVICE_UNAVAILABLE_WITH_ERRORS_FILENAME;

extern NSString *const SUCCESSFUL_CREATED_CLIENT_CREDENTIALS_FILENAME;
extern NSString *const SUCCESSFUL_CREATED_WITH_NO_BODY_FILENAME;
extern NSString *const SUCCESSFUL_OK_WITH_NO_BODY_FILENAME;

extern NSString *const SUCCESSFUL_OK_WITH_CLIENTS_LIST_EMPTY;
extern NSString *const SUCCESSFUL_OK_WITH_CLIENTS_LIST_ONE_CLIENT;
extern NSString *const SUCCESSFUL_OK_WITH_CLIENTS_LIST_MULTIPLE_CLIENTS;

extern NSString *const SUCCESSFUL_OK_WITH_REELS_LIST_EMPTY;
extern NSString *const SUCCESSFUL_OK_WITH_REELS_LIST_ONE_REEL;
extern NSString *const SUCCESSFUL_OK_WITH_REELS_LIST_MULTIPLE_REELS;

extern NSString *const SUCCESSFUL_OK_WITH_USERS_LIST_EMPTY;
extern NSString *const SUCCESSFUL_OK_WITH_USERS_LIST_ONE_USER;
extern NSString *const SUCCESSFUL_OK_WITH_USERS_LIST_MULTIPLE_USERS;

extern NSString *const SUCCESSFUL_OK_WITH_VIDEOS_LIST_EMPTY;
extern NSString *const SUCCESSFUL_OK_WITH_VIDEOS_LIST_ONE_VIDEO;
extern NSString *const SUCCESSFUL_OK_WITH_VIDEOS_LIST_MULTIPLE_VIDEOS;

extern NSString *const TOKEN_ERROR_BAD_CLIENT_CREDENTIALS_FILENAME;
extern NSString *const TOKEN_ERROR_BAD_CLIENT_CREDENTIALS_ERROR_CODE;
extern NSString *const TOKEN_ERROR_BAD_CLIENT_CREDENTIALS_ERROR_DESCRIPTION;

extern NSString *const TOKEN_ERROR_BAD_USER_CREDENTIALS_FILENAME;
extern NSString *const TOKEN_ERROR_BAD_USER_CREDENTIALS_ERROR_CODE;
extern NSString *const TOKEN_ERROR_BAD_USER_CREDENTIALS_ERROR_DESCRIPTION;

extern NSString *const TOKEN_ERROR_EXPIRED_ACCESS_TOKEN_FILENAME;
extern NSString *const TOKEN_ERROR_EXPIRED_ACCESS_TOKEN_ERROR_CODE;
extern NSString *const TOKEN_ERROR_EXPIRED_ACCESS_TOKEN_ERROR_DESCRIPTION;

extern NSString *const TOKEN_ERROR_EXPIRED_REFRESH_TOKEN_FILENAME;
extern NSString *const TOKEN_ERROR_EXPIRED_REFRESH_TOKEN_ERROR_CODE;
extern NSString *const TOKEN_ERROR_EXPIRED_REFRESH_TOKEN_ERROR_DESCRIPTION;

extern NSString *const SUCCESSFUL_TOKEN_FILENAME;
extern NSString *const SUCCESSFUL_TOKEN_TOKEN_TYPE;
extern NSString *const SUCCESSFUL_TOKEN_ACCESS_TOKEN;
extern NSString *const SUCCESSFUL_TOKEN_REFRESH_TOKEN;
extern NSString *const SUCCESSFUL_TOKEN_SCOPE;
extern const NSInteger SUCCESSFUL_TOKEN_EXPIRES_IN;

@interface RTClientSpecCallbackExpectation : NSObject

@property (readonly) void (^shouldNotExecute)(DoneCallback);

@property (readonly) SuccessCallback (^shouldExecuteSuccessCallback)(DoneCallback);

@property (readonly) SuccessCallback (^shouldNotExecuteSuccessCallback)(DoneCallback);

@property (readonly) FailureCallback (^shouldNotExecuteFailureCallback)(DoneCallback);

@property (readonly) FailureCallback (^shouldExecuteFailureCallbackWithMessage)(NSString *, DoneCallback);

@property (readonly) SuccessCallback (^shouldReceiveClientCredentialsInSuccessfulResponse)(DoneCallback);

@property (readonly) SuccessCallback (^shouldReceiveEmptyClientListInSuccessfulResponse)(DoneCallback);

@property (readonly) SuccessCallback (^shouldReceiveClientListWithOneClientInSuccessfulResponse)(DoneCallback);

@property (readonly) SuccessCallback (^shouldReceiveClientListWithMultipleClientsInSuccessfulResponse)(DoneCallback);

@property (readonly) SuccessCallback (^shouldReceiveEmptyReelListInSuccessfulResponse)(DoneCallback);

@property (readonly) SuccessCallback (^shouldReceiveReelListWithOneReelInSuccessfulResponse)(DoneCallback);

@property (readonly) SuccessCallback (^shouldReceiveReelListWithMultipleReelsInSuccessfulResponse)(DoneCallback);

@property (readonly) SuccessCallback (^shouldReceiveEmptyUserListInSuccessfulResponse)(DoneCallback);

@property (readonly) SuccessCallback (^shouldReceiveUserListWithOneUserInSuccessfulResponse)(DoneCallback);

@property (readonly) SuccessCallback (^shouldReceiveUserListWithMultipleUsersInSuccessfulResponse)(DoneCallback);

@property (readonly) SuccessCallback (^shouldReceiveEmptyVideoListInSuccessfulResponse)(DoneCallback);

@property (readonly) SuccessCallback (^shouldReceiveVideoListWithOneVideoInSuccessfulResponse)(DoneCallback);

@property (readonly) SuccessCallback (^shouldReceiveVideoListWithMultipleVideosInSuccessfulResponse)(DoneCallback);

@end
