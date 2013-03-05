//
//  NSDictionary+RMAdditions.h
//  RMFoundation
//
//  Created by Keith Duncan on 13/01/2011.
//  Copyright 2011 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RMAdditions)

+ (NSDictionary *)dictionaryWithParameterList:(NSString *)parameterList valueSeparator:(NSString *)valueSeparator pairDelimiter:(NSString *)pairDelimiter;

- (id)objectForCaseInsensitiveKey:(NSString *)key;

@end
