//***************************************************************************
 
// Copyright (C) 2009 Realmac Software Ltd
//
// These coded instructions, statements, and computer programs contain
// unpublished proprietary information of Realmac Software Ltd
// and are protected by copyright law. They may not be disclosed
// to third parties or copied or duplicated in any form, in whole or
// in part, without the prior written consent of Realmac Software Ltd.

// Created by Keith Duncan on 19/05/2009

//***************************************************************************

#import <Foundation/Foundation.h>

/*
	Feature Detection
 */

#if !defined(__has_builtin)
	#define __has_builtin(x) 0
#endif /* !defined(__has_builtin) */

#if !defined(__has_extension)
	#define __has_extension(x) 0
#endif /* !defined(__has_extension) */

#if !defined(__has_feature)
	#define __has_feature(x) 0
#endif /* !defined(__has_feature) */

#if !defined(__has_include)
	#define __has_include(x) 0
#endif /* !defined(__has_include) */

/*
	Types
 */

/*!
	\brief
	This #define simplifies the definition of external string constants.
 */
#define NSSTRING_CONSTANT(var) NSString *const var = @#var

/*!
	\brief
	This #define simplfies the definition of static observation contexts.
 */
#define NSSTRING_CONTEXT(var) static NSString *var = @#var

/*!
	\brief
	Provide a function that is invoked with a pointer to variable when the variable goes out of scope
 */
#define RM_SCOPE_EXIT(function) __attribute__((cleanup(function)))

static inline void RMCallScopedBlock(dispatch_block_t const *blockRef) {
	if (*blockRef != NULL) (*blockRef)();
}
// This is a shallow type making scope block declarations shorter
#define rm_scoped_block_t dispatch_block_t __attribute__((unused)) RM_SCOPE_EXIT(RMCallScopedBlock)

#if defined(NS_ENUM) && defined(NS_OPTIONS)
	#define RM_ENUM(_type, _name) NS_ENUM(_type, _name)
	#define RM_OPTIONS(_type, _name) NS_OPTIONS(_type, _name)
#elif (__cplusplus && __cplusplus >= 201103L && (__has_extension(cxx_strong_enums) || __has_feature(objc_fixed_enum))) || (!__cplusplus && __has_feature(objc_fixed_enum))
	#define RM_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
	#if (__cplusplus)
		#define RM_OPTIONS(_type, _name) _type _name; enum : _type
	#else
		#define RM_OPTIONS(_type, _name) enum _name : _type _name; enum _name : _type
	#endif
#else
	#define RM_ENUM(_type, _name) _type _name; enum
	#define RM_OPTIONS(_type, _name) _type _name; enum
#endif

/*
	Compiler Annotations
 */

#if __has_feature(attribute_analyzer_noreturn)
	#define RM_ANALYSER_NORETURN __attribute__((analyzer_noreturn))
#else
	#define RM_ANALYSER_NORETURN
#endif /* !defined(__has_feature(attribute_analyzer_noreturn)) */

/*
 
 */

#if defined(__clang__) && (__clang_major__ >= 3)

	#define RM_PROPERTY_ATOMIC atomic

#else

	#define RM_PROPERTY_ATOMIC

#endif /* defined(__clang__) && (__clang_major__ >= 3) */
