#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// This is a slightly modified version of ROArrayDataSource:
// https://github.com/raphaeloliveira/ArrayDataSource

typedef void (^ConfigureCellBlock)(id cell, id object);

@interface RTArrayDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSArray *items;
@property (copy, nonatomic) NSString *cellIdentifier;
@property (copy, nonatomic) ConfigureCellBlock configureCellBlock;

- (instancetype)initWithItems:(NSArray *)items
               cellIdentifier:(NSString *)cellIdentifier
           configureCellBlock:(ConfigureCellBlock)configureCellBlock;

@end
