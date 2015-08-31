#import "RTErrorCodeToErrorMessagePresenter.h"

#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"
#import "RTErrorCodeToErrorMessageMapping.h"

#import "RTLogging.h"

@interface RTErrorCodeToErrorMessagePresenter ()

@property id<RTErrorCodeToErrorMessagePresenterDelelgate> delegate;
@property id<RTErrorCodeToErrorMessageMapping> mapping;

@end

@implementation RTErrorCodeToErrorMessagePresenter

- (instancetype)initWithDelegate:(id<RTErrorCodeToErrorMessagePresenterDelelgate>)delegate
                         mapping:(id<RTErrorCodeToErrorMessageMapping>)mapping {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.mapping = mapping;
    }
    return self;
}

- (void)presentError:(NSError *)error {
    if ([error.domain isEqual:[self.mapping errorDomain]]) {
        NSDictionary *messages = [self.mapping errorCodeToErrorMessageMapping];

        NSInteger code = error.code;
        NSString *message = messages[@(code)];
        
        if (message) {
            [self.delegate presentErrorMessage:message forCode:code];
        }
    }
    else {
        DDLogWarn(@"Encountered unexpected error = %@", error);
    }
}

- (void)presentErrors:(NSArray *)errors {
    for (NSError *error in errors) {
        [self presentError:error];
    }
}

@end
