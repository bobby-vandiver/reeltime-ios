#import "RTResetPasswordDataManager.h"
#import "RTResetPasswordDataManagerDelegate.h"

#import "RTClient.h"

#import "RTUserCredentials.h"
#import "RTClientCredentials.h"

#import "RTServerErrors.h"
#import "RTServerErrorsConverter.h"

#import "RTResetPasswordServerErrorMapping.h"

@interface RTResetPasswordDataManager ()

@property (weak) id<RTResetPasswordDataManagerDelegate> delegate;
@property RTClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTResetPasswordDataManager

- (instancetype)initWithDelegate:(id<RTResetPasswordDataManagerDelegate>)delegate
                          client:(RTClient *)client {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.client = client;
        
        RTResetPasswordServerErrorMapping *mapping = [[RTResetPasswordServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)submitRequestForResetPasswordEmailForUsername:(NSString *)username
                                         withCallback:(NoArgsCallback)callback {
    NoArgsCallback successCallback = ^{
        callback();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSArray *emailErrors = [self.serverErrorsConverter convertServerErrors:serverErrors];
        [self.delegate submitRequestForResetPasswordEmailFailedWithErrors:emailErrors];
    };
    
    [self.client sendResetPasswordEmailForUsername:username
                                           success:successCallback
                                           failure:failureCallback];
}

- (void)resetPasswordToNewPassword:(NSString *)newPassword
                       forUsername:(NSString *)username
                 clientCredentials:(RTClientCredentials *)clientCredentials
                          withCode:(NSString *)code
                          callback:(NoArgsCallback)callback {
    
    RTUserCredentials *userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                                            password:newPassword];
    NoArgsCallback successCallback = ^{
        callback();
    };
    
    ServerErrorsCallback failureCallback = [self resetPasswordFailureCallback];
    
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
                          callback:(ClientCredentialsCallback)callback {
    
    RTUserCredentials *userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                                            password:newPassword];
    
    ClientCredentialsCallback successCallback = ^(RTClientCredentials *clientCredentials) {
        callback(clientCredentials);
    };
    
    ServerErrorsCallback failureCallback = [self resetPasswordFailureCallback];
    
    [self.client resetPasswordWithCode:code
                       userCredentials:userCredentials
                            clientName:clientName
                               success:successCallback
                               failure:failureCallback];
}

- (ServerErrorsCallback)resetPasswordFailureCallback {
    return ^(RTServerErrors *serverErrors) {
        NSArray *resetErrors = [self.serverErrorsConverter convertServerErrors:serverErrors];
        [self.delegate failedToResetPasswordWithErrors:resetErrors];
    };
}

@end
