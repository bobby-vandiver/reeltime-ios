#import <Foundation/Foundation.h>

@class RTClientDescription;

@protocol RTBrowseClientsView <NSObject>

- (void)showClientDescription:(RTClientDescription *)description;

- (void)clearClientDescriptions;

@end
