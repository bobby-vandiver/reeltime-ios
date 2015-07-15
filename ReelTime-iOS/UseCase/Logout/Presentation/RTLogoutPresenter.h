#import <Foundation/Foundation.h>
#import "RTLogoutInteractorDelegate.h"

@protocol RTLogoutView;
@class RTLogoutInteractor;
@class RTLogoutWireframe;

@interface RTLogoutPresenter : NSObject <RTLogoutInteractorDelegate>

- (instancetype)initWithView:(id<RTLogoutView>)view
                  interactor:(RTLogoutInteractor *)interactor
                   wireframe:(RTLogoutWireframe *)wireframe;

- (void)requestedLogout;

@end
