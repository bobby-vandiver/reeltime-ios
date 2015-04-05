#import <Foundation/Foundation.h>
#import "RTClient.h"

@protocol RTBrowseVideosDataManagerDelegate <NSObject>

- (void)listVideosPage:(NSUInteger)page
            withClient:(RTClient *)client
               success:(VideoListCallback)success
               failure:(ServerErrorsCallback)failure;

@end
