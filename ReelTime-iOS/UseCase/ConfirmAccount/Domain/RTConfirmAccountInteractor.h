#import <Foundation/Foundation.h>

@protocol RTConfirmAccountInteractorDelegate;
@class RTConfirmAccountDataManager;

@interface RTConfirmAccountInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTConfirmAccountInteractorDelegate>)delegate
                     dataManager:(RTConfirmAccountDataManager *)dataManager;

- (void)sendConfirmationEmail;

- (void)confirmAccountWithCode:(NSString *)code;

@end
