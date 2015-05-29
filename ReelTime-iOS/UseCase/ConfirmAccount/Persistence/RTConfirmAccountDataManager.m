#import "RTConfirmAccountDataManager.h"
#import "RTClient.h"

#import "RTServerErrors.h"
#import "RTServerErrorsConverter.h"

#import "RTConfirmAccountServerErrorMapping.h"

@interface RTConfirmAccountDataManager ()

@property RTClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTConfirmAccountDataManager

- (instancetype)initWithClient:(RTClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        
        RTConfirmAccountServerErrorMapping *mapping = [[RTConfirmAccountServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)submitRequestForConfirmationEmailWithEmailSent:(NoArgsCallback)emailSent
                                           emailFailed:(ArrayCallback)emailFailed {
    NoArgsCallback successCallback = ^{
        emailSent();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSArray *emailErrors = [self.serverErrorsConverter convertServerErrors:serverErrors];
        emailFailed(emailErrors);
    };
    
    [self.client sendAccountConfirmationEmailWithSuccess:successCallback
                                                 failure:failureCallback];
}

- (void)confirmAccountWithCode:(NSString *)code
           confirmationSuccess:(NoArgsCallback)success
                       failure:(ArrayCallback)failure {

    NoArgsCallback successCallback = ^{
        success();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSArray *confirmationErrors = [self.serverErrorsConverter convertServerErrors:serverErrors];
        failure(confirmationErrors);
    };
    
    [self.client confirmAccountWithCode:code
                                success:successCallback
                                failure:failureCallback];
}

@end
