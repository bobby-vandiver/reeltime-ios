#import <Foundation/Foundation.h>

@protocol RTCreateReelInteractorDelegate;
@class RTCreateReelDataManager;

@interface RTCreateReelInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTCreateReelInteractorDelegate>)delegate
                     dataManager:(RTCreateReelDataManager *)dataManager;

- (void)createReelWithName:(NSString *)name;

@end
