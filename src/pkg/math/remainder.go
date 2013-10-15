// Copyright 2010 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package math

// The original C code and the comment below are from
// FreeBSD's /usr/src/lib/msun/src/e_remainder.c and came
// with this notice.  The go code is a simplified version of
// the original C.
//
// ====================================================
// Copyright (C) 1993 by Sun Microsystems, Inc. All rights reserved.
//
// Developed at SunPro, a Sun Microsystems, Inc. business.
// Permission to use, copy, modify, and distribute this
// software is freely granted, provided that this notice
// is preserved.
// ====================================================
//
// __ieee754_remainder(x,y)
// Return :
//      returns  x REM y  =  x - [x/y]*y  as if in infinite
//      precision arithmetic, where [x/y] is the (infinite bit)
//      integer nearest x/y (in half way cases, choose the even one).
// Method :
//      Based on Mod() returning  x - [x/y]chopped * y  exactly.

// 原始C代码、详细注释、下面的常量以及此通知来自
// FreeBSD 的 /usr/src/lib/msun/src/e_remainder.c 文件。
// 此Go代码为原始C代码的简化版本。
//
//（版权声明见上。）
//
// __ieee754_remainder(x,y)
// 返回：
//      若以无限精度运算，则返回 x REM y  =  x - [x/y]*y，其中 [x/y]
//      为最接近 x/y 的（无限位）整数（若有两种选择，取偶数）
// 方法：
//      基于 Mod() 精确地返回 x - [x/y]chopped * y。

// Remainder returns the IEEE 754 floating-point remainder of x/y.
//
// Special cases are:
//	Remainder(±Inf, y) = NaN
//	Remainder(NaN, y) = NaN
//	Remainder(x, 0) = NaN
//	Remainder(x, ±Inf) = x
//	Remainder(x, NaN) = NaN

// Remainder 返回IEEE 754标准 x/y 的余数。
//
// 特殊情况为：
//	Remainder(±Inf, y) = NaN
//	Remainder(NaN, y)  = NaN
//	Remainder(x, 0)    = NaN
//	Remainder(x, ±Inf) = x
//	Remainder(x, NaN)  = NaN
func Remainder(x, y float64) float64

func remainder(x, y float64) float64 {
	const (
		Tiny    = 4.45014771701440276618e-308 // 0x0020000000000000
		HalfMax = MaxFloat64 / 2
	)
	// special cases
	// 特殊情况
	switch {
	case IsNaN(x) || IsNaN(y) || IsInf(x, 0) || y == 0:
		return NaN()
	case IsInf(y, 0):
		return x
	}
	sign := false
	if x < 0 {
		x = -x
		sign = true
	}
	if y < 0 {
		y = -y
	}
	if x == y {
		return 0
	}
	if y <= HalfMax {
		// 现在 x < 2y
		x = Mod(x, y+y) // now x < 2y
	}
	if y < Tiny {
		if x+x > y {
			x -= y
			if x+x >= y {
				x -= y
			}
		}
	} else {
		yHalf := 0.5 * y
		if x > yHalf {
			x -= y
			if x >= yHalf {
				x -= y
			}
		}
	}
	if sign {
		x = -x
	}
	return x
}
