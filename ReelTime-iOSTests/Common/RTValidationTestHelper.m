#import "RTValidationTestHelper.h"
#import <Expecta/Expecta.h>

NSString *const USERNAME_KEY = @"username";
NSString *const PASSWORD_KEY = @"password";
NSString *const CONFIRMATION_PASSWORD_KEY = @"confirmationPassword";
NSString *const EMAIL_KEY = @"email";
NSString *const DISPLAY_NAME_KEY = @"displayName";
NSString *const CLIENT_NAME_KEY = @"clientName";
NSString *const CONFIRMATION_CODE_KEY = @"confirmationCode";
NSString *const RESET_CODE_KEY = @"resetCode";

@interface RTValidationTestHelper ()

@property (nonatomic, copy) ValidationCallback validationCallback;
@property (nonatomic, copy) ErrorFactoryCallback errorFactoryCallback;

@end

@implementation RTValidationTestHelper

- (instancetype)initWithValidationCallback:(ValidationCallback)validationCallback
                      errorFactoryCallback:(ErrorFactoryCallback)errorFactoryCallback {
    self = [super init];
    if (self) {
        self.validationCallback = validationCallback;
        self.errorFactoryCallback = errorFactoryCallback;
    }
    return self;
}

- (void)expectErrorCodes:(NSArray *)errorCodes
           forParameters:(NSDictionary *)parameters {
    
    NSArray *errors;
    BOOL valid = self.validationCallback(parameters, &errors);

    expect(valid).to.beFalsy();
    expect(errors).toNot.beNil();
    
    [self expectErrorCodes:errorCodes forErrors:errors];
}

- (void)expectErrorCodes:(NSArray *)errorCodes
               forErrors:(NSArray *)errors {
    
    expect(errors).to.haveACountOf(errorCodes.count);
    
    for (NSNumber *errorCode in errorCodes) {
        NSError *error = self.errorFactoryCallback([errorCode integerValue]);
        expect(errors).to.contain(error);
    }
}

@end
