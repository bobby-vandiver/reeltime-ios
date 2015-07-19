#import <Foundation/Foundation.h>

@protocol RTJoinAudienceInteractorDelegate <NSObject>

- (void)joinAudienceSucceed;

- (void)joinAudienceFailedWithError:(NSError *)error;

@end
