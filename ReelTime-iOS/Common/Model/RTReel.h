#import <Foundation/Foundation.h>

@class RTUser;

@interface RTReel : NSObject

@property (nonatomic, copy) NSNumber *reelId;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSNumber *audienceSize;
@property (nonatomic, copy) NSNumber *numberOfVideos;

@property (nonatomic, copy) NSNumber *currentUserIsAnAudienceMember;
@property (nonatomic) RTUser *owner;

- (instancetype)initWithReelId:(NSNumber *)reelId
                          name:(NSString *)name
                  audienceSize:(NSNumber *)audienceSize
                numberOfVideos:(NSNumber *)numberOfVideos
 currentUserIsAnAudienceMember:(NSNumber *)currentUserIsAnAudienceMember
                         owner:(RTUser *)owner;

- (BOOL)isEqualToReel:(RTReel *)reel;

@end
