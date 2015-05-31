#import <Foundation/Foundation.h>
#import "RTAPIClient.h"

@protocol RTBrowseVideosDataManagerDelegate <NSObject>

- (void)listVideosPage:(NSUInteger)page
            withClient:(RTAPIClient *)client
               success:(VideoListCallback)success
               failure:(ServerErrorsCallback)failure;

@end
