#import "RTRestAPI.h"

#define API_VERSION_1_0(constName, endpoint) NSString *const constName = @"api/" endpoint;

NSString *const API_TOKEN = @"oauth/token";

API_VERSION_1_0(API_REGISTER_ACCOUNT,               "account");
API_VERSION_1_0(API_REMOVE_ACCOUNT,                 "account");

API_VERSION_1_0(API_REGISTER_CLIENT,                "account/client");
API_VERSION_1_0(API_REMOVE_CLIENT,                  "account/client/:client_id");

API_VERSION_1_0(API_CONFIRM_ACCOUNT,                "account/confirm");
API_VERSION_1_0(API_CONFIRM_ACCOUNT_SEND_EMAIL,     "account/confirm/email");

API_VERSION_1_0(API_CHANGE_DISPLAY_NAME,            "account/display_name");
API_VERSION_1_0(API_CHANGE_PASSWORD,                "account/password");

API_VERSION_1_0(API_RESET_PASSWORD,                 "account/password/reset");
API_VERSION_1_0(API_RESET_PASSWORD_SEND_EMAIL,      "account/password/reset/email");

API_VERSION_1_0(API_NEWSFEED,                       "newsfeed");

API_VERSION_1_0(API_VARIANT_PLAYLIST,               "playlists/:video_id");

API_VERSION_1_0(API_LIST_REELS,                     "reels");
API_VERSION_1_0(API_ADD_REEL,                       "reels");
API_VERSION_1_0(API_GET_REEL,                       "reels/:reel_id");
API_VERSION_1_0(API_DELETE_REEL,                    "reels/:reel_id");

API_VERSION_1_0(API_LIST_REEL_VIDEOS,               "reels/:reel_id/videos");
API_VERSION_1_0(API_ADD_REEL_VIDEO,                 "reels/:reel_id/videos");
API_VERSION_1_0(API_REMOVE_REEL_VIDEO,              "reels/:reel_id/videos/:video_id");

API_VERSION_1_0(API_LIST_AUDIENCE_MEMBERS,          "reels/:reel_id/audience");
API_VERSION_1_0(API_ADD_AUDIENCE_MEMBER,            "reels/:reel_id/audience");
API_VERSION_1_0(API_REMOVE_AUDIENCE_MEMBER,         "reels/:reel_id/audience");

API_VERSION_1_0(API_LIST_USERS,                     "users");
API_VERSION_1_0(API_GET_USER,                       "users/:username");

API_VERSION_1_0(API_LIST_USER_REELS,                "users/:username/reels");

API_VERSION_1_0(API_FOLLOW_USER,                    "users/:username/follow");
API_VERSION_1_0(API_UNFOLLOW_USER,                  "users/:username/follow");

API_VERSION_1_0(API_LIST_FOLLOWERS,                 "users/:username/followers");
API_VERSION_1_0(API_LIST_FOLLOWEES,                 "users/:username/followees");

API_VERSION_1_0(API_LIST_VIDEOS,                    "videos");
API_VERSION_1_0(API_ADD_VIDEO,                      "videos");
API_VERSION_1_0(API_GET_VIDEO,                      "videos/:video_id");
API_VERSION_1_0(API_DELETE_VIDEO,                   "videos/:video_id");
