#import <Foundation/Foundation.h>

@protocol RTReelWireframe <NSObject>

- (void)presentReelForReelId:(NSNumber *)reelId
               ownerUsername:(NSString *)ownerUsername;

@end
