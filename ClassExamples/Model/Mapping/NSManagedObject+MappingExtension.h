//
//  NSManagedObject+MappingExtension.h
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (MappingExtension)

+ (id)entityWithServerId:(NSString*)serverId inContext:(NSManagedObjectContext*)context;

- (NSDictionary*)dictionary;
- (void)setValuesWithDictionary:(NSDictionary *)keyedValues;


@end
