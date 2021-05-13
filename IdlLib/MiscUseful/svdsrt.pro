; Should routine called in eofcalc.pro

PRO SVDSRT, w,u,v,ROW=row,COLUMN=column
; sorts singular values and left and right singular vectors after call to
; svdc into order of descending singular value
su=size(u)
sv=size(v)
index=reverse(sort(w))
w=w(index)
if (keyword_set(column)) then begin
 for k=0, su(1)-1 do u(k,*)=u(k,index)
 for k=0, sv(1)-1 do v(k,*)=v(k,index)
endif else begin
 for k=0, su(2)-1 do u(*,k)=u(index,k)
 for k=0, sv(2)-1 do v(*,k)=v(index,k)
endelse
return
end
