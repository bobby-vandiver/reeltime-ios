#import <Foundation/Foundation.h>

#import "RTLoginDataManagerDelegate.h"

@protocol RTLoginInteractorDelegate;

@class RTLoginPresenter;
@class RTLoginDataManager;

@interface RTLoginInteractor : NSObject <RTLoginDataManagerDelegate>

- (instancetype)initWithDelegate:(id<RTLoginInteractorDelegate>)delegate
                     dataManager:(RTLoginDataManager *)dataManager;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password;

@end
