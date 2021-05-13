/* data structure for combined track data */

struct fet_pt_tr {
       int fr_id;             /* Frame id.                                   */
       long int time;         /* Frame time.                                 */
       int nfm;               /* Number of missing frames from current frame */
       int ix;                /* Nearest X-grid position                     */
       int iy;                /* Nearest Y-grid position                     */
       float xf;              /* Longitude position                          */
       float yf;              /* Latitude position                           */
       float zf;              /* Strength                                    */
       float gwthr;           /* Growth/decay rate, (1/f)df/dt               */
       float tend;            /* Tendency, df/dt                             */
       float vec[2];          /* Vector for velocities                       */
       float sh_an;           /* Anisotropy value                            */
       float or_vec[2];       /* Orientation vector                          */
       float wght;            /* Additional weighting for statistics         */
};

struct tot_tr {
       int num;
       int trid;
       int tr_sp;
       int eofs;
       int awt;
       long int time;
       struct fet_pt_tr *trpt;
};
