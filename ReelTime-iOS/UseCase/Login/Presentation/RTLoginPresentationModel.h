#import <Foundation/Foundation.h>
#import "RTConditionalMessage.h"

@interface RTLoginPresentationModel : NSObject

@property RTConditionalMessage *unknownErrorOccurred;

@property RTConditionalMessage *validUsername;
@property RTConditionalMessage *validPassword;
@property RTConditionalMessage *validCredentials;

@end
