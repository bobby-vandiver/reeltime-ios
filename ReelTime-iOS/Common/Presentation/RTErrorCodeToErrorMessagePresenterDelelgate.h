#import <Foundation/Foundation.h>

@protocol RTErrorCodeToErrorMessagePresenterDelelgate <NSObject>

- (void)presentErrorMessage:(NSString *)message
                    forCode:(NSInteger)code;

@end
