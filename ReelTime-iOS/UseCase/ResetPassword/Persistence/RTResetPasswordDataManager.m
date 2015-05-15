#import "RTResetPasswordDataManager.h"
#import "RTResetPasswordDataManagerDelegate.h"

#import "RTClient.h"
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
                                         withCallback:(void (^)())callback {
    NoArgsCallback successCallback = ^{
        callback();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSArray *emailErrors = [self.serverErrorsConverter convertServerErrors:serverErrors];
        [self.delegate sendResetEmailFailedWithErrors:emailErrors];
    };
    
    [self.client sendResetPasswordEmailForUsername:username
                                           success:successCallback
                                           failure:failureCallback];
}

- (void)resetPasswordToNewPassword:(NSString *)newPassword
                       forUsername:(NSString *)username
                 clientCredentials:(RTClientCredentials *)clientCredentials
                          withCode:(NSString *)code
                          callback:(void (^)())callback {
    
}

- (void)resetPasswordToNewPassword:(NSString *)newPassword
                       forUsername:(NSString *)username
                          withCode:(NSString *)code
   registerNewClientWithClientName:(NSString *)clientName
                          callback:(void (^)(RTClientCredentials *))callback {
    
}

@end
