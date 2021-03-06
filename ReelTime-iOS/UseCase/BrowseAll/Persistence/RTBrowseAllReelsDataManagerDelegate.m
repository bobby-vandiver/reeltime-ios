#import "RTBrowseAllReelsDataManagerDelegate.h"

@implementation RTBrowseAllReelsDataManagerDelegate

- (void)listReelsPage:(NSUInteger)page
           withClient:(RTAPIClient *)client
              success:(ReelListCallback)success
              failure:(ServerErrorsCallback)failure {
    
    [client listReelsPage:page
                  success:success
                  failure:failure];
}

@end
