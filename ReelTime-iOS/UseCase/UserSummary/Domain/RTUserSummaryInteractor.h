#import <Foundation/Foundation.h>
#import "RTUserSummaryDataManagerDelegate.h"

@protocol RTUserSummaryInteractorDelegate;
@class RTUserSummaryDataManager;

@interface RTUserSummaryInteractor : NSObject <RTUserSummaryDataManagerDelegate>

- (instancetype)initWithDelegate:(id<RTUserSummaryInteractorDelegate>)delegate
                     dataManager:(RTUserSummaryDataManager *)dataManager;

- (void)summaryForUsername:(NSString *)username;

@end
