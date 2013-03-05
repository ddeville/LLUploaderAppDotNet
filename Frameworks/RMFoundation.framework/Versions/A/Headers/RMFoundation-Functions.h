//
//  RMFoundation-Functions.h
//  RMFoundation
//
//  Created by Keith Duncan on 19/09/2011.
//  Copyright 2011 Realmac Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
	\brief
	Enumerate a linear list, recursion is detected.
 */
extern NSArray *RMFoundationUnionOfList(SEL nextNodeSelector, id head);

/*!
	\brief
	Enumerate a tree depth first
 */
extern NSArray *RMFoundationUnionOfTree(SEL childrenSelector, id currentNode);

/*!
	\brief
	Visit each node in a tree and invoke the block
*/
extern void RMFoundationVisitTree(SEL childrenSelector, id currentNode, void (^block)(id));
