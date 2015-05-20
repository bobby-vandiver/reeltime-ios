#import <Foundation/Foundation.h>

@protocol RTUserSummaryInteractorDelegate;
@class RTUserSummaryDataManager;

@interface RTUserSummaryInteractor : NSObject

- (instancetype)initWithDelegate:(id<RTUserSummaryInteractorDelegate>)delegate
                     dataManager:(RTUserSummaryDataManager *)dataManager;

- (void)summaryForUsername:(NSString *)username;

@end
