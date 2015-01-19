#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RTRestAPIMappingFactory : NSObject

+ (RKMapping *)tokenMapping;
+ (RKMapping *)tokenErrorMapping;

+ (RKMapping *)serverErrorsMapping;

+ (RKMapping *)accountRegistrationMapping;

@end
