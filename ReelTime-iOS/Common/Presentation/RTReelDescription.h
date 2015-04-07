#import <Foundation/Foundation.h>

@interface RTReelDescription : NSObject

@property (readonly, copy) NSString *name;
@property (readonly, copy) NSNumber *reelId;

@property (readonly, copy) NSNumber *audienceSize;
@property (readonly, copy) NSNumber *numberOfVideos;

@property (readonly, copy) NSString *ownerUsername;

+ (RTReelDescription *)reelDescriptionWithName:(NSString *)name
                                     forReelId:(NSNumber *)reelId
                                  audienceSize:(NSNumber *)audienceSize
                                numberOfVideos:(NSNumber *)numberOfVideos
                                 ownerUsername:(NSString *)ownerUsername;

@end
