#import "RTNoOpReelWireframe.h"
#import "RTLogging.h"

@implementation RTNoOpReelWireframe

- (void)presentReelForReelId:(NSNumber *)reelId
               ownerUsername:(NSString *)ownerUsername {
    DDLogWarn(@"No op wireframe received presentation request for reel id %@ with owner username = %@", reelId, ownerUsername);
}

@end
