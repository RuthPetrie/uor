function myrms,f,normalize=normalize,average=average
	        n=n_elements(f)
	        average=aver(f)
	        if keyword_set(normalize) then $
	                return,sqrt(aver((f-average)^2))/average $
	        else $
                return,sqrt(aver((f-average)^2))
	end
