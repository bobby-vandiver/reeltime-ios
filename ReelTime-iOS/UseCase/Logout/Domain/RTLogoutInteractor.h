#import <Foundation/Foundation.h>

@protocol RTLogoutInteractorDelegate;
@class RTLogoutDataManager;

@interface RTLogoutInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTLogoutInteractorDelegate>)delegate
                     dataManager:(RTLogoutDataManager *)dataManager;

- (void)logout;

@end
