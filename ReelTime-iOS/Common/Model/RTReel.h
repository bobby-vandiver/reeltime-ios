#import <Foundation/Foundation.h>

@class RTUser;

@interface RTReel : NSObject

@property (nonatomic, copy) NSNumber *reelId;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSNumber *audienceSize;
@property (nonatomic, copy) NSNumber *numberOfVideos;

@property (nonatomic) RTUser *owner;

//@property (nonatomic, copy) NSNumber *currentUserIsAnAudienceMember;

- (instancetype)initWithReelId:(NSNumber *)reelId
                          name:(NSString *)name
                  audienceSize:(NSNumber *)audienceSize
                numberOfVideos:(NSNumber *)numberOfVideos
                         owner:(RTUser *)owner;

- (BOOL)isEqualToReel:(RTReel *)reel;

@end
