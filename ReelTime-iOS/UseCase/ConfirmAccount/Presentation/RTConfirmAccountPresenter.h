#import <Foundation/Foundation.h>
#import "RTConfirmAccountInteractorDelegate.h"

@protocol RTConfirmAccountView;
@class RTConfirmAccountInteractor;

@interface RTConfirmAccountPresenter : NSObject <RTConfirmAccountInteractorDelegate>

- (instancetype)initWithView:(id<RTConfirmAccountView>)view
                  interactor:(RTConfirmAccountInteractor *)interactor;

- (void)requestedConfirmationEmail;

- (void)requestedConfirmationWithCode:(NSString *)code;

@end
