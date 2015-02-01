#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RTRestAPIMappingFactory : NSObject

+ (RKMapping *)tokenMapping;
+ (RKMapping *)tokenErrorMapping;

+ (RKMapping *)serverErrorsMapping;

// TODO: Rename to clientCredentialsMapping
+ (RKMapping *)accountRegistrationMapping;

+ (RKMapping *)userMapping;

+ (RKMapping *)reelMapping;

+ (RKMapping *)videoMapping;

+ (RKMapping *)activityMapping;

+ (RKMapping *)newsfeedMapping;

@end
