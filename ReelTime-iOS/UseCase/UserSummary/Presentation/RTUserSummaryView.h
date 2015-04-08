#import "RTUserDescriptionView.h"

@protocol RTUserSummaryView <RTUserDescriptionView>

- (void)showUserNotFoundMessage:(NSString *)message;

@end
