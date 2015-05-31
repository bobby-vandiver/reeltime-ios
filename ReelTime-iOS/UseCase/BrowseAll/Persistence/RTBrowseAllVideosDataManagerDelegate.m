#import "RTBrowseAllVideosDataManagerDelegate.h"

@implementation RTBrowseAllVideosDataManagerDelegate

- (void)listVideosPage:(NSUInteger)page
            withClient:(RTAPIClient *)client
               success:(VideoListCallback)success
               failure:(ServerErrorsCallback)failure {
    
    [client listVideosPage:page
                   success:success
                   failure:failure];
}

@end
