//
//  RMXPath.h
//  RMFoundation
//
//  Created by Keith Duncan on 25/01/2012.
//  Copyright (c) 2012 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSArray *RMFoundationXPathTokenise(NSString *XPath, NSError **errorRef);
extern NSString *RMFoundationXPathSerialise(NSArray *tokens);

/*!
	\brief
	This function converts an XPath with namespaces into an XPath suitable for use with the NSXML family of classes
	
	\details
	Given the following document:
	
	@@@
	<?xml encoding="utf-8"?>
	<root xmlns="http://realmacsoftware.com/namespaces/example.xml">
		<child>
			<grandchild/>
		</child>
		<child/>
		<child/>
	</root>
	@@@
	
	`[xmlDocument nodesForXPath:XPath error:NULL]` will return an empty array
	`[xmlDocument nodesForXPath:RMXMLPreprocessXPath(XPath, XPathNamespaces) error:NULL]` will return a populated array
	
	\param namespacesMap
	Map of prefix string to URI string
	
	\return
	An input XPath of the form `a:root` with namespacesMap of `{a: "http://realmacsoftware.com/namespaces/example.xml"}` becomes `*[local-name() = 'a' and string(namespace-uri()) = 'http://realmacsoftware.com/namespaces/example.xml']`
 */
extern NSString *RMFoundationXPathPreprocess(NSString *XPathWithNamespaces, NSDictionary *namespacesMap);
