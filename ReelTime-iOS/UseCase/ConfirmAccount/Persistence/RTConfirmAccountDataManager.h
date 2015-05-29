#import <Foundation/Foundation.h>
#import "RTCallback.h"

@class RTClient;

@interface RTConfirmAccountDataManager : NSObject

- (instancetype)initWithClient:(RTClient *)client;

- (void)submitRequestForConfirmationEmailWithEmailSent:(NoArgsCallback)emailSent
                                           emailFailed:(ArrayCallback)emailFailed;

- (void)confirmAccountWithCode:(NSString *)code
           confirmationSuccess:(NoArgsCallback)success
                       failure:(ArrayCallback)failure;

@end
