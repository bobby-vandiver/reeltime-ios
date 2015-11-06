#import <Foundation/Foundation.h>
#import "RTTestCallbacks.h"

extern NSString *const USERNAME_KEY;

extern NSString *const PASSWORD_KEY;
extern NSString *const CONFIRMATION_PASSWORD_KEY;

extern NSString *const EMAIL_KEY;
extern NSString *const DISPLAY_NAME_KEY;

extern NSString *const CLIENT_NAME_KEY;
extern NSString *const CLIENT_ID_KEY;

extern NSString *const CONFIRMATION_CODE_KEY;
extern NSString *const RESET_CODE_KEY;

extern NSString *const VIDEO_URL_KEY;
extern NSString *const THUMBNAIL_URL_KEY;

extern NSString *const VIDEO_TITLE_KEY;
extern NSString *const REEL_NAME_KEY;

@interface RTValidationTestHelper : NSObject

- (instancetype)initWithValidationCallback:(ValidationCallback)validationCallback
                      errorFactoryCallback:(ErrorFactoryCallback)errorFactoryCallback;

- (void)expectErrorCodes:(NSArray *)errorCodes
           forParameters:(NSDictionary *)parameters;

@end
