PRO show_vect
PSOPEN
CS, SCALE=1
GSET, XMIN=0, XMAX=10, YMIN=0, YMAX=10
GPLOT, X=1.5, Y=1.35, TEXT='TYPE='

PLOT_VECT, 10, 0, 2, 2, cstyle=0, maxmag=10, length=4, angle=22.5,$
            head_len=0.3, type=0, align=0.0, ref_text=''
GPLOT, X=2.25, Y=1.35, TEXT='0'

PLOT_VECT, 10, 0, 3, 2, cstyle=0, maxmag=10, length=4, angle=22.5,$
            head_len=0.3, type=1, align=0.0, ref_text=''
GPLOT, X=3.25, Y=1.35, TEXT='1'

PLOT_VECT, 10, 0, 4, 2, cstyle=0, maxmag=10, length=4, angle=22.5,$
            head_len=0.3, type=2, align=0.0, ref_text=''
GPLOT, X=4.25, Y=1.35, TEXT='2'

PLOT_VECT, 10, 0, 5, 2, cstyle=0, maxmag=10, length=4, angle=22.5,$
            head_len=0.3, type=3, align=0.0, ref_text=''
GPLOT, X=5.25, Y=1.35, TEXT='3'

PLOT_VECT, 10, 0, 6, 2, cstyle=0, maxmag=10, length=4, angle=22.5,$
            head_len=0.3, type=4, align=0.0, ref_text=''
GPLOT, X=6.25, Y=1.35, TEXT='4'

PSCLOSE
END
