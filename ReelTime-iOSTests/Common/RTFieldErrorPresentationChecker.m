#import "RTFieldErrorPresentationChecker.h"
#import "RTTestCommon.h"

@interface RTFieldErrorPresentationChecker ()

@property (weak) id<RTFieldValidationErrorView> view;

@property (nonatomic, copy) ArrayCallback errorsCallback;
@property (nonatomic, copy) ErrorFactoryCallback errorFactoryCallback;

@end

@implementation RTFieldErrorPresentationChecker

- (instancetype)initWithView:(id<RTFieldValidationErrorView>)view
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
       isShownForErrorCode:(NSInteger)code
                     field:(NSInteger)field {    
    NSError *error = self.errorFactoryCallback(code);
    self.errorsCallback(@[error]);
    
    [verify(self.view) showValidationErrorMessage:message forField:field];
    [verify(self.view) reset];
}

@end
