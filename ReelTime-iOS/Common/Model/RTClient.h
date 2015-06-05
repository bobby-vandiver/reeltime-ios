#import <Foundation/Foundation.h>

@interface RTClient : NSObject

@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *clientName;

- (instancetype)initWithClientId:(NSString *)clientId
                      clientName:(NSString *)clientName;

@end
