#import "RTErrorPresentationChecker.h"
#import "RTTestCommon.h"

@interface RTErrorPresentationChecker ()

@property (weak) id<RTErrorMessageView> view;

@property (nonatomic, copy) ArrayCallback errorsCallback;
@property (nonatomic, copy) ErrorFactoryCallback errorFactoryCallback;

@end

@implementation RTErrorPresentationChecker

- (instancetype)initWithView:(id<RTErrorMessageView>)view
              errorsCallback:(ArrayCallback)errorsCallback
        errorFactoryCallback:(ErrorFactoryCallback)errorFactoryCallback {
    
    self = [super init];
    if (self) {
        self.view = view;
        self.errorsCallback = errorsCallback;
        self.errorFactoryCallback = errorFactoryCallback;
    }
    return self;
}

- (void)verifyErrorMessage:(NSString *)message
       isShownForErrorCode:(NSInteger)code {
    [self executeErrorsCallbackWithErrorCode:code];
    
    [verify(self.view) showErrorMessage:message];
    [verify(self.view) reset];
}

- (void)verifyNoErrorMessageIsShownForErrorCode:(NSInteger)code {
    [self executeErrorsCallbackWithErrorCode:code];

    [verifyCount(self.view, never()) showErrorMessage:anything()];
    [verify(self.view) reset];
}

- (void)executeErrorsCallbackWithErrorCode:(NSInteger)code {
    NSError *error = self.errorFactoryCallback(code);
    self.errorsCallback(@[error]);
}

@end
