#import "RTBrowseReelVideosDataManagerDelegate.h"

@interface RTBrowseReelVideosDataManagerDelegate ()

@property NSUInteger reelId;

@end

@implementation RTBrowseReelVideosDataManagerDelegate

- (instancetype)initWithReelId:(NSUInteger)reelId {
    self = [super init];
    if (self) {
        self.reelId = reelId;
    }
    return self;
}

- (void)listVideosPage:(NSUInteger)page
            withClient:(RTClient *)client
               success:(VideoListCallback)success
               failure:(ServerErrorsCallback)failure {
    
    [client listVideosPage:page
         forReelWithReelId:self.reelId
                   success:success
                   failure:failure];
}

@end
