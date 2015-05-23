#import <Foundation/Foundation.h>

typedef BOOL (^ValidationCallback)(NSDictionary *parameters, NSArray *__autoreleasing *errors);

typedef NSError * (^ErrorFactoryCallback)(NSInteger errorCode);

extern NSString *const USERNAME_KEY;
extern NSString *const PASSWORD_KEY;
extern NSString *const CONFIRMATION_PASSWORD_KEY;
extern NSString *const CLIENT_NAME_KEY;
extern NSString *const RESET_CODE_KEY;

@interface RTValidationTestHelper : NSObject

- (instancetype)initWithValidationCallback:(ValidationCallback)validationCallback
                      errorFactoryCallback:(ErrorFactoryCallback)errorFactoryCallback;

- (void)expectErrorCodes:(NSArray *)errorCodes
           forParameters:(NSDictionary *)parameters;

@end
