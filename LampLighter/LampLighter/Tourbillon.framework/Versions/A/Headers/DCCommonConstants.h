//
//  DCCommonConstants.h
//  CodeGear_ObjC
//
//  Created by Derek Chen on 13-6-7.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#ifndef CodeGear_ObjC_DCCommonConstants_h
#define CodeGear_ObjC_DCCommonConstants_h

/**** **** **** **** **** **** **** ****/
//
// For Mac OS && iOS
//

#if defined(__MACH__)

#ifdef __cplusplus
#define DC_EXTERN extern "C"
#define DC_PRIVATE_EXTERN __private_extern__
#else
#define DC_EXTERN extern
#define DC_PRIVATE_EXTERN __private_extern__
#endif

//
// For Windows
//

#elif defined(WIN32)

#ifndef _NSBUILDING_COREDATA_DLL
#define _NSWINDOWS_DLL_GOOP __declspec(dllimport)
#else
#define _NSWINDOWS_DLL_GOOP __declspec(dllexport)
#endif

#ifdef __cplusplus
#define DC_EXTERN extern "C" _NSWINDOWS_DLL_GOOP
#define DC_PRIVATE_EXTERN extern
#else
#define DC_EXTERN _NSWINDOWS_DLL_GOOP extern
#define DC_PRIVATE_EXTERN extern
#endif

//
//  For Solaris
//

#elif defined(SOLARIS)

#ifdef __cplusplus
#define DC_EXTERN extern "C"
#define DC_PRIVATE_EXTERN extern "C"
#else
#define DC_EXTERN extern
#define DC_PRIVATE_EXTERN extern
#endif

#endif

/**** **** **** **** **** **** **** ****/
#define DC_MEMSIZE_KB(n) ((NSUInteger)(n * 1024))
#define DC_MEMSIZE_MB(n) ((NSUInteger)(DC_MEMSIZE_KB(n) * 1024))
#define DC_MEMSIZE_GB(n) ((NSUInteger)(DC_MEMSIZE_MB(n) * 1024))
/**** **** **** **** **** **** **** ****/
#ifndef DC_RGB_DEFINE
#define DC_RGB_DEFINE
#define DC_RGB(x) (((CGFloat)x) / 255.0f)
#endif
/**** **** **** **** **** **** **** ****/
#endif
