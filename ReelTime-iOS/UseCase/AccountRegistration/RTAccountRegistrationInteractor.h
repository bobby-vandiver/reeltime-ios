#import <Foundation/Foundation.h>

#import "RTAccountRegistrationDataManagerDelegate.h"

@protocol RTAccountRegistrationInteractorDelegate;

@class RTAccountRegistrationDataManager;
@class RTLoginInteractor;

@class RTAccountRegistration;

@interface RTAccountRegistrationInteractor : NSObject <RTAccountRegistrationDataManagerDelegate>

- (instancetype)initWithDelegate:(id<RTAccountRegistrationInteractorDelegate>)delegate
                     dataManager:(RTAccountRegistrationDataManager *)dataManager
                 loginInteractor:(RTLoginInteractor *)loginInteractor;

- (void)registerAccount:(RTAccountRegistration *)registration;

@end
