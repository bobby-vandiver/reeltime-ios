#import "RTChangePasswordDataManager.h"
#import "RTChangePasswordDataManagerDelegate.h"
#import "RTClient.h"

@interface RTChangePasswordDataManager ()

@property (weak) id<RTChangePasswordDataManagerDelegate> delegate;
@property RTClient *client;

@end

@implementation RTChangePasswordDataManager

- (instancetype)initWithDelegate:(id<RTChangePasswordDataManagerDelegate>)delegate
                          client:(RTClient *)client {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.client = client;
    }
    return self;
}

- (void)changePassword:(NSString *)password
              callback:(void (^)())callback {

    NoArgsCallback successCallback = ^{
        callback();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        
    };
    
    [self.client changePassword:password
                        success:successCallback
                        failure:failureCallback];
}

@end
