#import <Foundation/Foundation.h>

#import "RTCallbacks.h"
#import "RTTestCallbacks.h"
#import "RTErrorMessageView.h"

@interface RTErrorPresentationChecker : NSObject

- (instancetype)initWithView:(id<RTErrorMessageView>)view
              errorsCallback:(ArrayCallback)errorsCallback
        errorFactoryCallback:(ErrorFactoryCallback)errorFactoryCallback;

- (void)verifyErrorMessage:(NSString *)message
       isShownForErrorCode:(NSInteger)code;

@end
