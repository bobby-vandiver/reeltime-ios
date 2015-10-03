#import "RTOAuth2TokenRenegotiationStatus.h"
#import "RTLogging.h"

@interface RTOAuth2TokenRenegotiationStatus ()

@property NSCondition *condition;

@property (nonatomic) BOOL inProgress;
@property (nonatomic) BOOL succeeded;

@end

@implementation RTOAuth2TokenRenegotiationStatus

- (instancetype)init {
    self = [super init];
    if (self) {
        self.condition = [[NSCondition alloc] init];

        self.inProgress = NO;
        self.succeeded = NO;
    }
    return self;
}

- (BOOL)renegotiationInProgress {
    __block BOOL inProgress;
    
    [self performCriticalBlock:^{
        inProgress = self.inProgress;
    }];

    return inProgress;
}

- (BOOL)lastRenegotiationSucceeded {
    __block BOOL succeeded;
    
    [self performCriticalBlock:^{
        succeeded = self.succeeded;
    }];
    
    return succeeded;
}

- (void)renegotiationStarted {
    DDLogDebug(@"renegotiation started");
    
    [self performCriticalBlock:^{
        self.inProgress = YES;
        self.succeeded = NO;
    }];
}

- (void)renegotiationFinished:(BOOL)success {
    DDLogDebug(@"renegotiation finished -- success = %@", (success ? @"YES" : @"NO"));

    [self performCriticalBlock:^{
        self.inProgress = NO;
        self.succeeded = success;
        
        [self.condition signal];
    }];
}

- (void)waitUntilRenegotiationIsFinished:(NoArgsCallback)callback {
    DDLogDebug(@"waiting until renegotiation is finished...");

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [self performCriticalBlock:^{
            while (self.inProgress) {
                [self.condition wait];
            }
        }];
        
        callback();
    });
}

- (void)performCriticalBlock:(NoArgsCallback)block {
    [self.condition lock];
    block();
    [self.condition unlock];
}

@end
