#import <Foundation/Foundation.h>

#import "RTChangeDisplayNameInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTChangeDisplayNameView;
@class RTChangeDisplayNameInteractor;

@interface RTChangeDisplayNamePresenter : NSObject <RTChangeDisplayNameInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTChangeDisplayNameView>)view
                  interactor:(RTChangeDisplayNameInteractor *)interactor;

- (void)requestedDisplayNameChangeWithDisplayName:(NSString *)displayName;

@end
