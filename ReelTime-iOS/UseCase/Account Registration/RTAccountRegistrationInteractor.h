#import <Foundation/Foundation.h>

@class RTAccountRegistrationPresenter;
@class RTAccountRegistrationDataManager;

@interface RTAccountRegistrationInteractor : NSObject

- (instancetype)initWithPresenter:(RTAccountRegistrationPresenter *)presenter
                      dataManager:(RTAccountRegistrationDataManager *)dataManager;

- (void)registerAccountWithUsername:(NSString *)username
                           password:(NSString *)password
               confirmationPassword:(NSString *)confirmationPassword
                              email:(NSString *)email
                        displayName:(NSString *)displayName
                         clientName:(NSString *)clientName;

@end
