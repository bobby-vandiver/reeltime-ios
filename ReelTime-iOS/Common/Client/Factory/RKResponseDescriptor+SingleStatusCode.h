#import <RestKit/RestKit.h>

@interface RKResponseDescriptor (SingleStatusCode)

+ (RKResponseDescriptor *)responseDescriptorWithMapping:(RKMapping *)mapping
                                                 method:(RKRequestMethod)method
                                            pathPattern:(NSString *)pathPattern
                                            statusCodes:(NSIndexSet *)statusCodes;
 
+ (RKResponseDescriptor *)responseDescriptorWithMapping:(RKMapping *)mapping
                                                 method:(RKRequestMethod)method
                                            pathPattern:(NSString *)pathPattern
                                             statusCode:(NSUInteger)statusCode;

@end