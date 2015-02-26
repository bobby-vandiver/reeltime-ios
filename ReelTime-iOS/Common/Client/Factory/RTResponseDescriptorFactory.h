#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RTResponseDescriptorFactory : NSObject

+ (RKResponseDescriptor *)tokenDescriptor;
+ (RKResponseDescriptor *)tokenErrorDescriptor;

+ (RKResponseDescriptor *)accountRegistrationDescriptor;
+ (RKResponseDescriptor *)accountRegistrationErrorDescriptor;

+ (RKResponseDescriptor *)clientRegistrationDescriptor;

+ (RKResponseDescriptor *)newsfeedDescriptor;

@end
