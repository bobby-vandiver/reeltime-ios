#import <Foundation/Foundation.h>

#import "RTRemoveAccountInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTRemoveAccountView;
@class RTRemoveAccountInteractor;
@class RTRemoveAccountWireframe;

@interface RTRemoveAccountPresenter : NSObject <RTRemoveAccountInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTRemoveAccountView>)view
                  interactor:(RTRemoveAccountInteractor *)interactor
                   wireframe:(RTRemoveAccountWireframe *)wireframe;

- (void)requestedAccountRemoval;

@end
