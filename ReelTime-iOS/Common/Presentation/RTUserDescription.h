#import <Foundation/Foundation.h>

@interface RTUserDescription : NSObject

@property (readonly, copy) NSString *displayName;
@property (readonly, copy) NSString *username;

+ (RTUserDescription *)userDescriptionWithDisplayName:(NSString *)displayName
                                          forUsername:(NSString *)username;

@end
