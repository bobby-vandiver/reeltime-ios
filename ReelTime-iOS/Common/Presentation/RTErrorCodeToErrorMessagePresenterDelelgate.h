#import <Foundation/Foundation.h>

@protocol RTErrorCodeToErrorMessagePresenterDelelgate <NSObject>

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code;

@optional

- (void)failedToPresentError:(NSError *)error;

@end
