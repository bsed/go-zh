// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/*
 * Runtime type representation; master is type.go
 *
 * The Type*s here correspond 1-1 to type.go's *rtype.
 */

typedef struct Type Type;
typedef struct UncommonType UncommonType;
typedef struct InterfaceType InterfaceType;
typedef struct Method Method;
typedef struct IMethod IMethod;
typedef struct SliceType SliceType;
typedef struct FuncType FuncType;

// Needs to be in sync with ../../cmd/ld/decodesym.c:/^commonsize,
// pkg/reflect/type.go:/type anf type.go:/rtype
struct Type
{
	uintptr size;
	uint32 hash;
	uint8 _unused;
	uint8 align;
	uint8 fieldAlign;
	uint8 kind;
	Alg *alg;
	// gc stores type info required for garbage collector.
	// If (kind&KindGCProg)==0, then gc directly contains sparse GC bitmap
	// (no indirection), 4 bits per word.
	// If (kind&KindGCProg)!=0, then gc[1] points to a compiler-generated
	// read-only GC program; and gc[0] points to BSS space for sparse GC bitmap.
	// For huge types (>MaxGCMask), runtime unrolls the program directly into
	// GC bitmap and gc[0] is not used. For moderately-sized types, runtime
	// unrolls the program into gc[0] space on first use. The first byte of gc[0]
	// (gc[0][0]) contains 'unroll' flag saying whether the program is already
	// unrolled into gc[0] or not.
	uintptr gc[2];
	String *string;
	UncommonType *x;
	Type *ptrto;
	byte *zero;  // ptr to the zero value for this type
};

struct Method
{
	String *name;
	String *pkgPath;
	Type	*mtyp;
	Type *typ;
	void (*ifn)(void);
	void (*tfn)(void);
};

struct UncommonType
{
	String *name;
	String *pkgPath;
	Slice mhdr;
	Method m[];
};

struct IMethod
{
	String *name;
	String *pkgPath;
	Type *type;
};

struct InterfaceType
{
	Type;
	Slice mhdr;
	IMethod m[];
};

struct MapType
{
	Type;
	Type *key;
	Type *elem;
	Type *bucket; // internal type representing a hash bucket
	Type *hmap;   // internal type representing a Hmap
};

struct ChanType
{
	Type;
	Type *elem;
	uintptr dir;
};

struct SliceType
{
	Type;
	Type *elem;
};

struct FuncType
{
	Type;
	bool dotdotdot;
	Slice in;
	Slice out;
};

struct PtrType
{
	Type;
	Type *elem;
};
