#import <Foundation/Foundation.h>

@protocol RTRemoveAccountInteractorDelegate;
@class RTRemoveAccountDataManager;

@interface RTRemoveAccountInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTRemoveAccountInteractorDelegate>)delegate
                     dataManager:(RTRemoveAccountDataManager *)dataManager;

- (void)removeAccount;

@end
