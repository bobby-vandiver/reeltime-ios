#import <Foundation/Foundation.h>

@protocol RTChangePasswordInteractorDelegate;
@class RTChangePasswordDataManager;

@interface RTChangePasswordInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTChangePasswordInteractorDelegate>)delegate
                     dataManager:(RTChangePasswordDataManager *)dataManager;

- (void)changePassword:(NSString *)password
  confirmationPassword:(NSString *)confirmationPassword;

@end
