#import <Foundation/Foundation.h>

@interface RTReel : NSObject

@property (nonatomic, copy) NSNumber *reelId;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSNumber *audienceSize;
@property (nonatomic, copy) NSNumber *numberOfVideos;

- (instancetype)initWithReelId:(NSNumber *)reelId
                          name:(NSString *)name
                  audienceSize:(NSNumber *)audienceSize
                numberOfVideos:(NSNumber *)numberOfVideos;

@end
