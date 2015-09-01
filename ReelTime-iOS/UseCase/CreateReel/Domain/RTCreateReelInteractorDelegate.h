#import <Foundation/Foundation.h>

@protocol RTCreateReelInteractorDelegate <NSObject>

- (void)createReelSucceededForName:(NSString *)name;

- (void)createReelFailedForName:(NSString *)name
                      withError:(NSError *)error;

@end
