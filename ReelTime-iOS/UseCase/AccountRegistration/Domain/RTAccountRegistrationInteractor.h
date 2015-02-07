#import <Foundation/Foundation.h>

#import "RTAccountRegistrationDataManagerDelegate.h"

@protocol RTAccountRegistrationInteractorDelegate;

@class RTAccountRegistrationDataManager;
@class RTAccountRegistrationValidator;
@class RTLoginInteractor;

@class RTAccountRegistration;

@interface RTAccountRegistrationInteractor : NSObject <RTAccountRegistrationDataManagerDelegate>

- (instancetype)initWithDelegate:(id<RTAccountRegistrationInteractorDelegate>)delegate
                     dataManager:(RTAccountRegistrationDataManager *)dataManager
                       validator:(RTAccountRegistrationValidator *)validator
                 loginInteractor:(RTLoginInteractor *)loginInteractor;

- (void)registerAccount:(RTAccountRegistration *)registration;

@end
