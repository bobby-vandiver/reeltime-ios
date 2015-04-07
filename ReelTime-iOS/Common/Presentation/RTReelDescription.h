#import <Foundation/Foundation.h>

@interface RTReelDescription : NSObject

@property (readonly, copy) NSString *text;
@property (readonly, copy) NSNumber *reelId;
@property (readonly, copy) NSString *ownerUsername;

+ (RTReelDescription *)reelDescriptionWithText:(NSString *)text
                                     forReelId:(NSNumber *)reelId
                                 ownerUsername:(NSString *)ownerUsername;

@end
