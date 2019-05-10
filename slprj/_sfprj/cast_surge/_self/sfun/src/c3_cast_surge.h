#ifndef __c3_cast_surge_h__
#define __c3_cast_surge_h__

/* Type Definitions */
#ifndef struct_tag_s1eTpAM3l49H1qmKQgaS0pB
#define struct_tag_s1eTpAM3l49H1qmKQgaS0pB

struct tag_s1eTpAM3l49H1qmKQgaS0pB
{
  uint32_T Method;
  uint32_T Seed;
  uint32_T State[625];
  uint32_T LegacyRandnState[2];
};

#endif                                 /*struct_tag_s1eTpAM3l49H1qmKQgaS0pB*/

#ifndef typedef_c3_s1eTpAM3l49H1qmKQgaS0pB
#define typedef_c3_s1eTpAM3l49H1qmKQgaS0pB

typedef struct tag_s1eTpAM3l49H1qmKQgaS0pB c3_s1eTpAM3l49H1qmKQgaS0pB;

#endif                                 /*typedef_c3_s1eTpAM3l49H1qmKQgaS0pB*/

#include <time.h>
#ifndef struct_tag_sxaDueAh1f53T9ESYg9Uc4E
#define struct_tag_sxaDueAh1f53T9ESYg9Uc4E

struct tag_sxaDueAh1f53T9ESYg9Uc4E
{
  real_T tm_min;
  real_T tm_sec;
  real_T tm_hour;
  real_T tm_mday;
  real_T tm_mon;
  real_T tm_year;
};

#endif                                 /*struct_tag_sxaDueAh1f53T9ESYg9Uc4E*/

#ifndef typedef_c3_sxaDueAh1f53T9ESYg9Uc4E
#define typedef_c3_sxaDueAh1f53T9ESYg9Uc4E

typedef struct tag_sxaDueAh1f53T9ESYg9Uc4E c3_sxaDueAh1f53T9ESYg9Uc4E;

#endif                                 /*typedef_c3_sxaDueAh1f53T9ESYg9Uc4E*/

#ifndef typedef_SFc3_cast_surgeInstanceStruct
#define typedef_SFc3_cast_surgeInstanceStruct

typedef struct {
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  int32_T c3_sfEvent;
  uint8_T c3_tp_Cast;
  uint8_T c3_tp_Surge;
  uint8_T c3_tp_Leftward;
  uint8_T c3_tp_Rightward;
  uint8_T c3_tp_Initialize;
  uint8_T c3_is_active_c3_cast_surge;
  uint8_T c3_is_c3_cast_surge;
  uint8_T c3_is_Cast;
  real_T c3_th;
  real_T c3_upwind[2];
  real_T c3_dir[2];
  void *c3_RuntimeVar;
  uint32_T c3_method;
  boolean_T c3_method_not_empty;
  uint32_T c3_state[2];
  boolean_T c3_state_not_empty;
  uint32_T c3_b_method;
  boolean_T c3_b_method_not_empty;
  uint32_T c3_b_state;
  boolean_T c3_b_state_not_empty;
  uint32_T c3_c_state[2];
  boolean_T c3_c_state_not_empty;
  uint32_T c3_d_state[625];
  boolean_T c3_d_state_not_empty;
  uint32_T c3_seed;
  boolean_T c3_seed_not_empty;
  boolean_T c3_dataWrittenToVector[6];
  uint8_T c3_doSetSimStateSideEffects;
  const mxArray *c3_setSimStateSideEffectsInfo;
  uint32_T c3_mlFcnLineNumber;
  void *c3_fEmlrtCtx;
  real_T *c3_e_state;
  real_T *c3_pos_x;
  real_T *c3_pos_y;
} SFc3_cast_surgeInstanceStruct;

#endif                                 /*typedef_SFc3_cast_surgeInstanceStruct*/

/* Named Constants */

/* Variable Declarations */
extern struct SfDebugInstanceStruct *sfGlobalDebugInstanceStruct;

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c3_cast_surge_get_eml_resolved_functions_info(void);

/* Function Definitions */
extern void sf_c3_cast_surge_get_check_sum(mxArray *plhs[]);
extern void c3_cast_surge_method_dispatcher(SimStruct *S, int_T method, void
  *data);

#endif
