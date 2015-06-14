#import <Foundation/Foundation.h>

#import "RTConfirmAccountInteractorDelegate.h"
#import "RTErrorCodeToErrorMessagePresenterDelelgate.h"

@protocol RTConfirmAccountView;
@class RTConfirmAccountInteractor;

@interface RTConfirmAccountPresenter : NSObject <RTConfirmAccountInteractorDelegate, RTErrorCodeToErrorMessagePresenterDelelgate>

- (instancetype)initWithView:(id<RTConfirmAccountView>)view
                  interactor:(RTConfirmAccountInteractor *)interactor;

- (void)requestedConfirmationEmail;

- (void)requestedConfirmationWithCode:(NSString *)code;

@end
