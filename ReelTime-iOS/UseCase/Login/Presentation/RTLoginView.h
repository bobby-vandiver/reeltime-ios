#import <Foundation/Foundation.h>

@class RTLoginPresentationModel;

@protocol RTLoginView <NSObject>

- (void)updateWithPresentationModel:(RTLoginPresentationModel *)model;

@end
