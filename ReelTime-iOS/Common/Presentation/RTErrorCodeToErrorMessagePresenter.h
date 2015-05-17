#import <Foundation/Foundation.h>

@protocol RTErrorCodeToErrorMessagePresenterDelelgate;
@protocol RTErrorCodeToErrorMessageMapping;

@interface RTErrorCodeToErrorMessagePresenter : NSObject

- (instancetype)initWithDelegate:(id<RTErrorCodeToErrorMessagePresenterDelelgate>)delegate
                         mapping:(id<RTErrorCodeToErrorMessageMapping>)mapping;


- (void)presentErrors:(NSArray *)errors;

@end
