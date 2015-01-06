#import <Foundation/Foundation.h>

#import "RTLoginView.h"

@class RTLoginInteractor;
@class RTLoginWireframe;

@interface RTLoginPresenter : NSObject

- (instancetype)initWithView:(id<RTLoginView>)view
                  interactor:(RTLoginInteractor *)interactor
                   wireframe:(RTLoginWireframe *)wireframe;

- (void)requestedLoginWithUsername:(NSString *)username
                           password:(NSString *)password;

- (void)loginSucceeded;

- (void)loginFailedWithError:(NSError *)error;

@end
