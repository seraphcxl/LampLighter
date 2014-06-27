//
//  DCAtomicSetters.h
//  Tourbillon
//
//  Created by Derek Chen on 13-10-15.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#ifndef Tourbillon_DCAtomicSetters_h
#define Tourbillon_DCAtomicSetters_h

// See http://www.opensource.apple.com/source/objc4/objc4-371.2/runtime/Accessors.subproj/objc-accessors.h
extern void objc_setProperty(id self, SEL _cmd, ptrdiff_t offset, id newValue, BOOL atomic, BOOL shouldCopy);
extern id objc_getProperty(id self, SEL _cmd, ptrdiff_t offset, BOOL atomic);
extern void objc_copyStruct(void *dest, const void *src, ptrdiff_t size, BOOL atomic, BOOL hasStrong);

#define DCAtomicRetainedSetToFrom(dest, source) objc_setProperty(self, _cmd, (ptrdiff_t)(&dest) - (ptrdiff_t)(self), source, YES, NO)
#define DCAtomicCopiedSetToFrom(dest, source) objc_setProperty(self, _cmd, (ptrdiff_t)(&dest) - (ptrdiff_t)(self), source, YES, YES)
#define DCAtomicAutoreleasedGet(source) objc_getProperty(self, _cmd, (ptrdiff_t)(&source) - (ptrdiff_t)(self), YES)
#define DCAtomicStructToFrom(dest, source) objc_copyStruct(&dest, &source, sizeof(__typeof__(source)), YES, NO)

#endif
