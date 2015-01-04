#import <Foundation/Foundation.h>

#import "RTLoginView.h"
#import "RTError.h"

@class RTLoginInteractor;

@interface RTLoginPresenter : NSObject

- (instancetype)initWithView:(id<RTLoginView>)view
                  interactor:(RTLoginInteractor *)interactor;

- (void)requestedLoginWithUsername:(NSString *)username
                           password:(NSString *)password;

- (void)loginSucceeded;

- (void)loginFailedWithError:(RTError *)error;

@end
