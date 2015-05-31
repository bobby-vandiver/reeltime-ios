#import "RTResetPasswordDataManager.h"

#import "RTAPIClient.h"

#import "RTUserCredentials.h"
#import "RTClientCredentials.h"

#import "RTServerErrors.h"
#import "RTServerErrorsConverter.h"

#import "RTResetPasswordServerErrorMapping.h"

@interface RTResetPasswordDataManager ()

@property RTAPIClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTResetPasswordDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        
        RTResetPasswordServerErrorMapping *mapping = [[RTResetPasswordServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)submitRequestForResetPasswordEmailForUsername:(NSString *)username
                                            emailSent:(NoArgsCallback)emailSent
                                          emailFailed:(ArrayCallback)emailFailed {
    NoArgsCallback successCallback = ^{
        emailSent();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSArray *emailErrors = [self.serverErrorsConverter convertServerErrors:serverErrors];
        emailFailed(emailErrors);
    };
    
    [self.client sendResetPasswordEmailForUsername:username
                                           success:successCallback
                                           failure:failureCallback];
}

- (void)resetPasswordToNewPassword:(NSString *)newPassword
                       forUsername:(NSString *)username
                 clientCredentials:(RTClientCredentials *)clientCredentials
                          withCode:(NSString *)code
              passwordResetSuccess:(NoArgsCallback)success
                           failure:(ArrayCallback)failure {
    
    RTUserCredentials *userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                                            password:newPassword];
    NoArgsCallback successCallback = ^{
        success();
    };
    
    ServerErrorsCallback failureCallback = [self resetPasswordFailureWithCallback:failure];
    
    [self.client resetPasswordWithCode:code
                       userCredentials:userCredentials
                     clientCredentials:clientCredentials
                               success:successCallback
                               failure:failureCallback];
}

- (void)resetPasswordToNewPassword:(NSString *)newPassword
                       forUsername:(NSString *)username
                          withCode:(NSString *)code
   registerNewClientWithClientName:(NSString *)clientName
              passwordResetSuccess:(ClientCredentialsCallback)success
                           failure:(ArrayCallback)failure {
    
    RTUserCredentials *userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                                            password:newPassword];
    
    ClientCredentialsCallback successCallback = ^(RTClientCredentials *clientCredentials) {
        success(clientCredentials);
    };
    
    ServerErrorsCallback failureCallback = [self resetPasswordFailureWithCallback:failure];
    
    [self.client resetPasswordWithCode:code
                       userCredentials:userCredentials
                            clientName:clientName
                               success:successCallback
                               failure:failureCallback];
}

- (ServerErrorsCallback)resetPasswordFailureWithCallback:(ArrayCallback)callback {
    return ^(RTServerErrors *serverErrors) {
        NSArray *resetErrors = [self.serverErrorsConverter convertServerErrors:serverErrors];
        callback(resetErrors);
    };
}

@end
