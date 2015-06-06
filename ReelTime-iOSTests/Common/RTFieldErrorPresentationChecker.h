#import <Foundation/Foundation.h>

#import "RTCallbacks.h"
#import "RTTestCallbacks.h"
#import "RTFieldValidationErrorView.h"

@interface RTFieldErrorPresentationChecker : NSObject

- (instancetype)initWithView:(id<RTFieldValidationErrorView>)view
              errorsCallback:(ArrayCallback)errorsCallback
        errorFactoryCallback:(ErrorFactoryCallback)errorFactoryCallback;

- (void)verifyErrorMessage:(NSString *)message
       isShownForErrorCode:(NSInteger)code
                     field:(NSInteger)field;

- (void)verifyMultipleErrorMessagesAreShownForErrorCodes:(NSArray *)codes
                                 withFieldMessageMapping:(NSDictionary *)mapping;

@end
