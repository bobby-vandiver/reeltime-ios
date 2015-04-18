#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// This is a slightly modified version of ROArrayDataSource:
// https://github.com/raphaeloliveira/ArrayDataSource

typedef void (^ConfigureCellBlock)(id cell, id object);

@interface RTArrayDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>

@property (strong) NSArray *items;
@property (copy) NSString *cellIdentifier;
@property (copy, nonatomic) ConfigureCellBlock configureCellBlock;

+ (instancetype)rowMajorArrayWithItems:(NSArray *)items
                        cellIdentifier:(NSString *)cellIdentifier
                    configureCellBlock:(ConfigureCellBlock)configureCellBlock;

+ (instancetype)sectionMajorArrayWithItems:(NSArray *)items
                            cellIdentifier:(NSString *)cellIdentifier
                        configureCellBlock:(ConfigureCellBlock)configureCellBlock;

@end
