;+
; NAME:
; SORT_ND
;
; PURPOSE:
;
; Efficiently perform an N-dimensional sort along any dimension
; of an array.
;
; CALLING SEQUENCE:
;
; inds=sort_nd(array,dimension)
;
; INPUTS:
;
; array: An array of at least 2 dimensions to sort.
;
; dimension: The dimension along which to sort, starting at 1
; (1:rows, 2:columns, ...).
;
; OUTPUTS:
;
; inds: An index array with the same dimensions as the input
; array, containing the (1D) sorted indices. Can be used
; directly to index the arary (ala SORT).
;
; EXAMPLE:
;
; a=randomu(sd,5,4,3,2)
; sorted=a[sort_nd(a,2)]
;
; SEE ALSO:
;
; HISTOGRAM
;
; MODIFICATION HISTORY:
;
; Tue Aug 22 15:51:12 2006, J.D. Smith <jdsmith@as.arizona.edu>
;


;-
;################################################# #############################
;
; LICENSE
;
; Copyright (C) 2006 J.D. Smith
;
; This file is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published
; by the Free Software Foundation; either version 2, or (at your
; option) any later version.
;
; This file is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
; General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this file; see the file COPYING. If not, write to the
; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
; Boston, MA 02110-1301, USA.
;
;################################################# #############################

FUNCTION SORT_ND, ARRAY,DIMENSION

sz = SIZE(array,/DIMENSIONS)
ndim = N_ELEMENTS(sz)
s = SORT(array)

IF dimension EQ 1 THEN BEGIN ; mark along dimension with index
   inds = s/sz[0]
ENDIF ELSE BEGIN
   p = product(sz,/CUMULATIVE,/PRESERVE_TYPE)
   inds = s MOD p[dimension-2]
   IF dimension LT ndim THEN inds += s/p[dimension-1]*p[dimension-2]
ENDELSE

h = HISTOGRAM(inds,REVERSE_INDICES=ri)
ri = s[ri[N_ELEMENTS(temporary(h))+1:*]]
IF dimension EQ 1 THEN RETURN, REFORM(ri,sz,/OVERWRITE) $
ELSE BEGIN ; target dimension is collected to front, rearrange it
   t = [dimension-1,WHERE(LINDGEN(ndim) NE dimension-1)]
   ri = REFORM(ri,sz[t],/OVERWRITE)
   RETURN, TRANSPOSE(ri,SORT(t))
ENDELSE
END
