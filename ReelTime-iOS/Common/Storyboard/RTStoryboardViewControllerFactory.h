#import <Foundation/Foundation.h>

@protocol RTStoryboardViewController;

@interface RTStoryboardViewControllerFactory : NSObject

+ (id)storyboardViewController:(Class<RTStoryboardViewController>)clazz;

@end
