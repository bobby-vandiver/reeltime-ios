#import <Foundation/Foundation.h>
#import "RTLoginView.h"

@interface RTLoginPresenter : NSObject

- (instancetype)initWithView:(id<RTLoginView>)view;

- (void)requestedLoginWithUsername:(NSString *)username
                           password:(NSString *)password;

- (void)loginSucceeded;

- (void)loginFailedWithError:(NSError *)error;

@end
