#import <Foundation/Foundation.h>
#import "RTUserSummaryInteractorDelegate.h"

@protocol RTUserSummaryView;
@class RTUserSummaryInteractor;

@interface RTUserSummaryPresenter : NSObject <RTUserSummaryInteractorDelegate>

- (instancetype)initWithView:(id<RTUserSummaryView>)view
                  interactor:(RTUserSummaryInteractor *)interactor;

- (void)requestedSummaryForUsername:(NSString *)username;

@end
