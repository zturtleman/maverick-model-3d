Maverick Model 3D adds support for Quake III: Team Arena and others mods (such as Turtle Arena).

These changes are required to export the Turtle Arena players from mm3d to md3.

# Changes #
Incomplete list of changes.

## Fixes ##
  * Fixed saving MD3 player models with no frame animations.

## MDR ##
  * Unfinished support for MDR models. MDR models are basically skeleton animated MD3 models.

  * Compressed MDR models only allow bone joints in the range of -512 to 511. If your model is bigger set MDR\_compressed to 0.

## Animation Looping ##
  * "Loop" in the Animation Mode is now per-animation (with undo support)
  * Loop is read and wrote to and fro .mm3d files (compatible with current .mm3d files)
  * Per-animation loop is supported by md3filter (No more handcoded list)

## Head model animations ##
  * Added support for `"HEAD_"` (animates head model, like `TORSO_` and `LEGS_`) and `"ALL_"` (animates torso, legs, and head, like `BOTH_`) animations.

## Animations.cfg ##
  * Animation names are loaded from the animations.cfg, with fallback to default Quake3 names, instead of just a hardcoded list.

  * Reads/Saves all of the animations instead of just the first 25 (MD3\_ANIMATIONS).

## Metadata ##
  * Changes add suppport for `MD3_CFG_*` metadata to insert data into animations.cfg
    * (Still supports hardcoded MD3\_footsteps, MD3\_headoffset, etc)
    * Example: "MD3\_CFG\_abilty" "tech" metadata writes "abilty tech" to animations.cfg

  * If MD3\_NoSyncWarning value is 1 does not add sync warning to animations in animations.cfg

  * If MD3\_EliteLoop value is 1 uses STV: Elite Force Single Player style loopframes
    * (Where 0 is loop, and -1 is don't loop in animations.cfg)

  * If MD3\_AnimKeyword value is 1 uses Elite Force Single Player style animation list
    * Example: "BOTH\_DEATH1 0 5 5 15"

  * If MDR\_compressed value is 0 does not compress the MDR model(s).