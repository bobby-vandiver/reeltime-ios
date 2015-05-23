#import <Foundation/Foundation.h>
#import "RTValidator.h"

@protocol RTChangePasswordInteractorDelegate;
@class RTChangePasswordDataManager;

@interface RTChangePasswordInteractor : RTValidator

- (instancetype)initWithDelegate:(id<RTChangePasswordInteractorDelegate>)delegate
                     dataManager:(RTChangePasswordDataManager *)dataManager;

- (void)changePassword:(NSString *)password
  confirmationPassword:(NSString *)confirmationPassword;

@end
