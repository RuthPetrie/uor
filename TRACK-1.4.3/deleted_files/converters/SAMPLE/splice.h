
/* data structure for combined track data */

struct fet_pt_tr {
       int fr_id;             /* frame id.                                   */
       int nfm;               /* number of missing frames from current frame */
       int ix;                /* nearest X-grid position                     */
       int iy;                /* nearest Y-grid position                     */
       float xf;              /* longitude position                          */
       float yf;              /* latitude position                           */
       float zf;              /* strength                                    */
       float gwthr;           /* growth/decay rate, (1/f)df/dt               */
       float tend;            /* tendency, df/dt                             */
       float vec[2];          /* vector for velocities                       */
       float sh_an;           /* anisotropy value                            */
       float or_vec[2];       /* orientation vector                          */
       float wght;            /* additional weighting for statistics         */
};

struct tot_tr {
       int num;
       int tr_sp;
       int eofs;
       int awt;
       struct fet_pt_tr *trpt;
};
