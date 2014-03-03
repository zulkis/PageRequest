//
//  NSManagedObject+MappingExtension.m
//

#import "NSManagedObject+MappingExtension.h"

@implementation NSManagedObject (MappingExtension)

+ (NSDictionary*)mappingDictionaryFrontendKeysForBackendKeys {
  @throw [NSException exceptionWithName:@"Override exception" reason:@"Override me" userInfo:nil];
}

+ (NSString*)backendKeyForFrontendKey:(NSString*)key {
  return [[[self mappingDictionaryFrontendKeysForBackendKeys] allKeysForObject:key] lastObject];
}

+ (NSString*)frontendKeyForBackendKey:(NSString*)key {
  return [self mappingDictionaryFrontendKeysForBackendKeys][key];
}

- (id)valueForUndefinedKey:(NSString *)key {
  NSString *frontEndKey = [[self class] frontendKeyForBackendKey:key];
  if (frontEndKey) {
    if ([[key componentsSeparatedByString:@"."] count] > 1) {
      return [self valueForKeyPath:frontEndKey];
    }
    return [self valueForKey:frontEndKey];
  }
  return nil;
}

+ (id)entityWithServerId:(NSString*)serverId inContext:(NSManagedObjectContext*)context {
  return [self findFirstByAttribute:@"serverID" withValue:serverId inContext:context];
}

- (void)setValuesWithDictionary:(NSDictionary *)keyedValues {
  [keyedValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    if ([obj isKindOfClass:[NSNull class]]) {
      obj = nil;
    }
    NSString *frontEndKey = [[self class] frontendKeyForBackendKey:key];
    BOOL isKeyPath = [[frontEndKey componentsSeparatedByString:@"."] count] > 1;
    if (frontEndKey) {                                                 //...We need to set it for our key or keypath
      if ([obj isKindOfClass:[NSDictionary class]]) {
        [self setDictionary:obj forKey:frontEndKey];
      } else if ([obj isKindOfClass:[NSArray class]]) {
        [self setArray:obj forKey:frontEndKey];
      } else if (isKeyPath) {                                          //... for keypath
        
        // TODO: need create entity if relationship is nil
        [self setValue:obj forKeyPath:frontEndKey];
      } else {                                                         //... for key
        [self setValue:obj forKey:frontEndKey];
      }
    } else {                                                           //... just setting it directly using kvc
      if ([self respondsToSelector:NSSelectorFromString(key)]) {
        if (isKeyPath) {
          [self setValue:obj forKeyPath:key];
        } else {
          [self setValue:obj forKey:key];
        }
      }
    }
  }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  DBGLog(@"Cannot setValue:%@ forUndefinderKey:%@", value, key);
}

- (void)setArray:(NSArray*)array forKey:(NSString *)aKey {
  NSString *frontEndKey = [[self class] frontendKeyForBackendKey:aKey];
  NSDictionary *relationships = [[self entity] relationshipsByName];
  NSRelationshipDescription *relationshipDescription = relationships[frontEndKey];
  Class frontendClass = NSClassFromString([relationshipDescription.destinationEntity managedObjectClassName]);
  for (NSDictionary *dict in array) {
    if ([dict isKindOfClass:[NSString class]]) {
      @throw [NSException exceptionWithName:@"name" reason:@"NEED IMP FOR STRINGS" userInfo:@{@"string":dict}];
    } else if ([dict isKindOfClass:[NSDictionary class]]) {
      NSManagedObject *entity = nil;
      NSString *serverIDKey = [frontendClass frontendKeyForBackendKey:@"_id"];
      if (serverIDKey) {
        entity = [frontendClass entityWithServerId:dict[@"_id"] inContext:self.managedObjectContext];
      }
      if (!entity) {
        entity = [frontendClass createInContext:self.managedObjectContext];
      }
      [entity setValue:self forKey:relationshipDescription.inverseRelationship.name];
      [entity setValuesWithDictionary:dict];
    }
  }
}

- (void)setDictionary:(NSDictionary*)dict forKey:(NSString *)aKey {
  NSDictionary *relationships = [[self entity] relationshipsByName];
  NSRelationshipDescription *relationshipDescription = relationships[aKey];
  id relationship = [self valueForKey:aKey];
  if (!relationship && relationshipDescription) {
    Class aClass = NSClassFromString([relationshipDescription.destinationEntity managedObjectClassName]);
    NSString *serverIDKey = [aClass frontendKeyForBackendKey:@"_id"];
    if (serverIDKey) {
      relationship = [aClass entityWithServerId:dict[@"_id"] inContext:self.managedObjectContext];
    }
    if (!relationship) {
      relationship = [aClass createInContext:self.managedObjectContext];
    }
    [self setValue:relationship forKey:aKey];
  }
  [relationship setValuesWithDictionary:dict];
}

- (NSDictionary*)dictionary {
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  NSDictionary *attributes = [[self entity] attributesByName];
  for (NSString *attribute in attributes) {
    if ([self valueForKey:attribute])
      dict[attribute] = [self valueForKey:attribute];
  }
  return dict;
}

@end
