#import <Foundation/Foundation.h>

@interface RTReelDescription : NSObject

@property (readonly, copy) NSString *name;
@property (readonly, copy) NSNumber *reelId;
@property (readonly, copy) NSString *ownerUsername;

+ (RTReelDescription *)reelDescriptionWithName:(NSString *)name
                                     forReelId:(NSNumber *)reelId
                                 ownerUsername:(NSString *)ownerUsername;

@end
