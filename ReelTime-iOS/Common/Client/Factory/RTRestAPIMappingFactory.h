#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RTRestAPIMappingFactory : NSObject

+ (RKMapping *)tokenMapping;
+ (RKMapping *)tokenErrorMapping;

+ (RKMapping *)serverErrorsMapping;

+ (RKMapping *)clientCredentialsMapping;

+ (RKMapping *)userMapping;

+ (RKMapping *)reelMapping;

+ (RKMapping *)videoMapping;

+ (RKMapping *)activityMapping;

+ (RKMapping *)newsfeedMapping;

@end
