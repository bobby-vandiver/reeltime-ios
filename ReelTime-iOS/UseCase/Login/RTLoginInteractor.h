#import <Foundation/Foundation.h>

@class RTLoginPresenter;
@class RTLoginDataManager;

@interface RTLoginInteractor : NSObject

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter
                      dataManager:(RTLoginDataManager *)dataManager;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password;

@end
