#import <Foundation/Foundation.h>

extern NSString *actualValueIsNil();
extern NSString *expectedValueIsNil(NSString *valueIdentifier);

extern NSString *actualIsClass(Class actualClass, Class expectedClass);
extern NSString *actualIsNotClass(Class actualClass, Class expectedClass);

extern NSString *actualIsExpected(NSString *valueIdentifier, id actual, id expected);
extern NSString *actualIsNotExpected(NSString *valueIdentifier, id actual, id expected);
