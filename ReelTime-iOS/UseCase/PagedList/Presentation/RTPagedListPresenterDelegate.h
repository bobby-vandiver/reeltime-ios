#import <Foundation/Foundation.h>

@protocol RTPagedListPresenterDelegate <NSObject>

- (void)clearPresentedItems;

- (void)presentItem:(id)item;

@end
