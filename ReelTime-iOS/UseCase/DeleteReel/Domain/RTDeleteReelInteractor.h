#import <Foundation/Foundation.h>

@protocol RTDeleteReelInteractorDelegate;
@class RTDeleteReelDataManager;

@interface RTDeleteReelInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTDeleteReelInteractorDelegate>)delegate
                     dataManager:(RTDeleteReelDataManager *)dataManager;

- (void)deleteReelWithReelId:(NSNumber *)reelId;

@end
