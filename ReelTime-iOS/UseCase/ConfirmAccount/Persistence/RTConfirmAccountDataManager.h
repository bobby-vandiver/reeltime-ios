#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTAPIClient;

@interface RTConfirmAccountDataManager : NSObject

- (instancetype)initWithClient:(RTAPIClient *)client;

- (void)submitRequestForConfirmationEmailWithEmailSent:(NoArgsCallback)emailSent
                                           emailFailed:(ArrayCallback)emailFailed;

- (void)confirmAccountWithCode:(NSString *)code
           confirmationSuccess:(NoArgsCallback)success
                       failure:(ArrayCallback)failure;

@end
