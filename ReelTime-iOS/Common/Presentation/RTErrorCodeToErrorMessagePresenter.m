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

- (void)presentErrors:(NSArray *)errors {
    NSDictionary *messages = [self.mapping errorCodeToErrorMessageMapping];
    
    for (NSError *error in errors) {
        if ([error.domain isEqual:[self.mapping errorDomain]]) {
            
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
}

@end
