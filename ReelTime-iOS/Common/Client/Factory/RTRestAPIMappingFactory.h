#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RTRestAPIMappingFactory : NSObject

+ (RKMapping *)tokenMapping;

+ (RKMapping *)tokenErrorMapping;

+ (RKMapping *)serverErrorsMapping;

+ (RKMapping *)clientCredentialsMapping;

+ (RKMapping *)clientMapping;

+ (RKMapping *)clientListMapping;

+ (RKMapping *)userMapping;

+ (RKMapping *)userListMapping;

+ (RKMapping *)reelMapping;

+ (RKMapping *)reelListMapping;

+ (RKMapping *)videoMapping;

+ (RKMapping *)videoListMapping;

+ (RKMapping *)activityMapping;

+ (RKMapping *)newsfeedMapping;

+ (RKMapping *)emptyMapping;

@end
