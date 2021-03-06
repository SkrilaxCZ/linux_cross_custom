# Copyright (C) 1991-2005,2007,2011,2012 Free Software Foundation, Inc.
# This file is part of the GNU C Library.

# The GNU C Library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.

# The GNU C Library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public
# License along with the GNU C Library; if not, see
# <http://www.gnu.org/licenses/>.

#
#	Makefile for time routines
#
include ../option-groups.mak

subdir	:= time

headers	:= time.h sys/time.h sys/timeb.h bits/time.h

routines := offtime asctime clock ctime ctime_r difftime \
	    gmtime localtime mktime time		 \
	    gettimeofday settimeofday adjtime tzset	 \
	    tzfile getitimer setitimer			 \
	    stime dysize timegm ftime			 \
	    getdate strptime strptime_l			 \
	    strftime strftime_l				 \
	    timespec_get
routines-$(OPTION_POSIX_C_LANG_WIDE_CHAR)		 \
	 := wcsftime wcsftime_l
aux-$(OPTION_EGLIBC_LOCALE_CODE) += alt_digit era lc-time-cleanup

tests	:= test_time clocktest tst-posixtz \
	   tst-getdate tst-mktime tst-mktime2 tst-strftime \
	   tst-mktime3 tst-strptime2 bug-asctime bug-asctime_r bug-mktime1 \
	   tst-strptime3 bug-getdate1
tests-$(OPTION_EGLIBC_LOCALE_CODE) \
	+= tst-strptime tst-ftime_l
tests-$(OPTION_POSIX_WIDE_CHAR_DEVICE_IO) \
	+= tst_wcsftime

include ../Rules

tz-cflags = -DTZDIR='"$(zonedir)"' \
	    -DTZDEFAULT='"$(localtime-file)"' \
	    -DTZDEFRULES='"$(posixrules-file)"'

CFLAGS-tzfile.c = $(tz-cflags)
CFLAGS-tzset.c = $(tz-cflags)
CFLAGS-getdate.c = -fexceptions

# Don't warn about Y2k problem in strftime format string.
CFLAGS-test_time.c = -Wno-format

tst-getdate-ENV= DATEMSK=datemsk TZDIR=${common-objpfx}timezone/testdata
test_time-ARGS= EST5EDT CST

tst-strptime-ENV = LOCPATH=${common-objpfx}localedata
tst-ftime_l-ENV = LOCPATH=${common-objpfx}localedata

bug-getdate1-ARGS = ${objpfx}bug-getdate1-fmt
