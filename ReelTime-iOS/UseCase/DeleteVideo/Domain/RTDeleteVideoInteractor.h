#import <Foundation/Foundation.h>

@protocol RTDeleteVideoInteractorDelegate;
@class RTDeleteVideoDataManager;

@interface RTDeleteVideoInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTDeleteVideoInteractorDelegate>)delegate
                     dataManager:(RTDeleteVideoDataManager *)dataManager;

- (void)deleteVideoWithVideoId:(NSNumber *)videoId;

@end
