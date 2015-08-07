#import <Foundation/Foundation.h>

@interface RTClientDescription : NSObject

@property (readonly, copy) NSString *clientId;
@property (readonly, copy) NSString *clientName;

+ (RTClientDescription *)clientDescriptionWithClientId:(NSString *)clientId
                                            clientName:(NSString *)clientName;

- (BOOL)isEqualToClientDescription:(RTClientDescription *)clientDescription;

@end
