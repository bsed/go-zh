// Copyright 2014 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build linux
// +build power64 power64le

#include "textflag.h"

//
// System calls for Power64, Linux
//

// func Syscall(trap int64, a1, a2, a3 int64) (r1, r2, err int64);

TEXT	·Syscall(SB),NOSPLIT,$0-56
	BL	runtime·entersyscall(SB)
	MOVD	a1+8(FP), R3
	MOVD	a2+16(FP), R4
	MOVD	a3+24(FP), R5
	MOVD	R0, R6
	MOVD	R0, R7
	MOVD	R0, R8
	MOVD	trap+0(FP), R9	// syscall entry
	SYSCALL R9
	BVC	ok
	MOVD	$-1, R4
	MOVD	R4, r1+32(FP)	// r1
	MOVD	R0, r2+40(FP)	// r2
	MOVD	R3, err+48(FP)	// errno
	BL	runtime·exitsyscall(SB)
	RETURN
ok:
	MOVD	R3, r1+32(FP)	// r1
	MOVD	R4, r2+40(FP)	// r2
	MOVD	R0, err+48(FP)	// errno
	BL	runtime·exitsyscall(SB)
	RETURN

TEXT ·Syscall6(SB),NOSPLIT,$0-80
	BL	runtime·entersyscall(SB)
	MOVD	a1+8(FP), R3
	MOVD	a2+16(FP), R4
	MOVD	a3+24(FP), R5
	MOVD	a4+32(FP), R6
	MOVD	a5+40(FP), R7
	MOVD	a6+48(FP), R8
	MOVD	trap+0(FP), R9	// syscall entry
	SYSCALL R9
	BVC	ok6
	MOVD	$-1, R4
	MOVD	R4, r1+56(FP)	// r1
	MOVD	R0, r2+64(FP)	// r2
	MOVD	R3, err+72(FP)	// errno
	BL	runtime·exitsyscall(SB)
	RETURN
ok6:
	MOVD	R3, r1+56(FP)	// r1
	MOVD	R4, r2+64(FP)	// r2
	MOVD	R0, err+72(FP)	// errno
	BL	runtime·exitsyscall(SB)
	RETURN

TEXT ·RawSyscall(SB),NOSPLIT,$0-56
	MOVD	a1+8(FP), R3
	MOVD	a2+16(FP), R4
	MOVD	a3+24(FP), R5
	MOVD	R0, R6
	MOVD	R0, R7
	MOVD	R0, R8
	MOVD	trap+0(FP), R9	// syscall entry
	SYSCALL R9
	BVC	ok1
	MOVD	$-1, R4
	MOVD	R4, r1+32(FP)	// r1
	MOVD	R0, r2+40(FP)	// r2
	MOVD	R3, err+48(FP)	// errno
	RETURN
ok1:
	MOVD	R3, r1+32(FP)	// r1
	MOVD	R4, r2+40(FP)	// r2
	MOVD	R0, err+48(FP)	// errno
	RETURN

TEXT ·RawSyscall6(SB),NOSPLIT,$0-80
	MOVD	a1+8(FP), R3
	MOVD	a2+16(FP), R4
	MOVD	a3+24(FP), R5
	MOVD	a4+32(FP), R6
	MOVD	a5+40(FP), R7
	MOVD	a6+48(FP), R8
	MOVD	trap+0(FP), R9	// syscall entry
	SYSCALL R9
	BVC	ok2
	MOVD	$-1, R4
	MOVD	R4, r1+56(FP)	// r1
	MOVD	R0, r2+64(FP)	// r2
	MOVD	R3, err+72(FP)	// errno
	RETURN
ok2:
	MOVD	R3, r1+56(FP)	// r1
	MOVD	R4, r2+64(FP)	// r2
	MOVD	R0, err+72(FP)	// errno
	RETURN
