#import "RTTestCommon.h"

#import "RTArrayDataSource.h"

SpecBegin(RTArrayDataSource)

describe(@"array data source", ^{
    
    __block UITableView *tableView;
    __block UICollectionView *collectionView;
    
    __block NSMutableArray *items;
    
    __block NSObject *item1;
    __block NSObject *item2;
    
    beforeEach(^{
        tableView = mock([UITableView class]);
        collectionView = mock([UICollectionView class]);
        
        items = [NSMutableArray array];

        item1 = [NSObject new];
        item2 = [NSObject new];
    });
    
    context(@"row major data source", ^{
        __block RTArrayDataSource *rowMajorDataSource;
        
        beforeEach(^{
            rowMajorDataSource = [RTArrayDataSource rowMajorArrayWithItems:items
                                                            cellIdentifier:@"RowMajor"
                                                        configureCellBlock:nil];
        });
        
        it(@"number of table rows equals number of items", ^{
            NSInteger rows = [rowMajorDataSource tableView:tableView numberOfRowsInSection:0];
            expect(rows).to.equal(0);
            
            [items addObject:item1];
            
            rows = [rowMajorDataSource tableView:tableView numberOfRowsInSection:0];
            expect(rows).to.equal(1);

            [items addObject:item2];

            rows = [rowMajorDataSource tableView:tableView numberOfRowsInSection:0];
            expect(rows).to.equal(2);
        });
        
        it(@"number of table sections is fixed at 1", ^{
            NSInteger sections = [rowMajorDataSource numberOfSectionsInTableView:tableView];
            expect(sections).to.equal(1);
        });
        
        it(@"number of collection items equals number of items", ^{
            NSInteger count = [rowMajorDataSource collectionView:collectionView numberOfItemsInSection:0];
            expect(count).to.equal(0);
            
            [items addObject:item1];
            
            count = [rowMajorDataSource collectionView:collectionView numberOfItemsInSection:0];
            expect(count).to.equal(1);
            
            [items addObject:item2];

            count = [rowMajorDataSource collectionView:collectionView numberOfItemsInSection:0];
            expect(count).to.equal(2);
        });
        
        it(@"number of collection items in section is fixed at 1", ^{
            NSInteger sections = [rowMajorDataSource numberOfSectionsInCollectionView:collectionView];
            expect(sections).to.equal(1);
        });
    });
    
    context(@"section major data source", ^{
        __block RTArrayDataSource *sectionMajorDataSource;
        
        beforeEach(^{
            sectionMajorDataSource = [RTArrayDataSource sectionMajorArrayWithItems:items
                                                                    cellIdentifier:@"SectionMajor"
                                                                configureCellBlock:nil];
        });
        
        it(@"number of table sections equals number of items", ^{
            NSInteger sections = [sectionMajorDataSource numberOfSectionsInTableView:tableView];
            expect(sections).to.equal(0);
            
            [items addObject:item1];
            
            sections = [sectionMajorDataSource numberOfSectionsInTableView:tableView];
            expect(sections).to.equal(1);
            
            [items addObject:item2];
            
            sections = [sectionMajorDataSource numberOfSectionsInTableView:tableView];
            expect(sections).to.equal(2);
        });
        
        it(@"number of table rows per section is fixed at 1", ^{
            NSInteger rows = [sectionMajorDataSource tableView:tableView numberOfRowsInSection:0];
            expect(rows).to.equal(1);
        });
        
        it(@"number of collection sections equals number of items", ^{
            NSInteger sections = [sectionMajorDataSource numberOfSectionsInCollectionView:collectionView];
            expect(sections).to.equal(0);
            
            [items addObject:item1];
            
            sections = [sectionMajorDataSource numberOfSectionsInCollectionView:collectionView];
            expect(sections).to.equal(1);
            
            [items addObject:item2];
            
            sections = [sectionMajorDataSource numberOfSectionsInCollectionView:collectionView];
            expect(sections).to.equal(2);
        });
        
        it(@"number of collection items per section is fixed at 1", ^{
            NSInteger count = [sectionMajorDataSource collectionView:collectionView numberOfItemsInSection:0];
            expect(count).to.equal(1);
        });
    });
});

SpecEnd
