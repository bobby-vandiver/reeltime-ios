#import <Foundation/Foundation.h>

@protocol RTChangeDisplayNameInteractorDelegate;
@class RTChangeDisplayNameDataManager;

@interface RTChangeDisplayNameInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTChangeDisplayNameInteractorDelegate>)delegate
                     dataManager:(RTChangeDisplayNameDataManager *)dataManager;

- (void)changeDisplayName:(NSString *)displayName;

@end
