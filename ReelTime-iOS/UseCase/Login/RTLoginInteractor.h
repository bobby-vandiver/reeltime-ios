#import <Foundation/Foundation.h>

#import "RTLoginInteractorDelegate.h"
#import "RTLoginDataManagerDelegate.h"

@class RTLoginPresenter;
@class RTLoginDataManager;

@interface RTLoginInteractor : NSObject <RTLoginDataManagerDelegate>

- (instancetype)initWithDelegate:(id<RTLoginInteractorDelegate>)delegate
                     dataManager:(RTLoginDataManager *)dataManager;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password;

@end
