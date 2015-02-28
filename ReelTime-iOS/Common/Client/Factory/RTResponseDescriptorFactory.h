#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RTResponseDescriptorFactory : NSObject

+ (RKResponseDescriptor *)tokenDescriptor;
+ (RKResponseDescriptor *)tokenErrorDescriptor;

+ (RKResponseDescriptor *)accountRegistrationDescriptor;
+ (RKResponseDescriptor *)accountRegistrationErrorDescriptor;

+ (RKResponseDescriptor *)accountRemovalDescriptor;

+ (RKResponseDescriptor *)clientRegistrationDescriptor;
+ (RKResponseDescriptor *)clientRegistrationErrorDescriptor;

+ (RKResponseDescriptor *)clientRemovalDescriptor;

+ (RKResponseDescriptor *)accountConfirmationDescriptor;
+ (RKResponseDescriptor *)accountConfirmationErrorDescriptor;

+ (RKResponseDescriptor *)newsfeedDescriptor;

@end
