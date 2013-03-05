//
//  NSBundle+RMAdditions.h
//  RMFoundation
//
//  Created by Keith Duncan on 07/11/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (RMFoundationAdditions)

@end

// nil bundle safe localised string variants

#define RMLocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) (bundle != nil ? [bundle localizedStringForKey:(key) value:(val) table:(tbl)] : (val))
#define RMLocalizedStringFromTableInBundle(key, tbl, bundle, comment) RMLocalizedStringWithDefaultValue(key, tbl, bundle, key, comment)
#define RMLocalizedStringFromTable(key, tbl, comment) RMLocalizedStringFromTableInBundle(key, tbl, [NSBundle mainBundle], comment)
#define RMLocalizedString(key, comment) RMLocalizedStringFromTable(key, nil, comment)
