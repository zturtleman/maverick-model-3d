#
# Maverick Model 3D Makefile
#
# GNU Make required
#

COMPILE_PLATFORM=$(shell uname|sed -e s/_.*//|tr '[:upper:]' '[:lower:]'|sed -e 's/\//_/g')

COMPILE_ARCH=$(shell uname -m | sed -e s/i.86/i386/)

ifeq ($(COMPILE_PLATFORM),sunos)
  # Solaris uname and GNU uname differ
  COMPILE_ARCH=$(shell uname -p | sed -e s/i.86/i386/)
endif
ifeq ($(COMPILE_PLATFORM),darwin)
  # Apple does some things a little differently...
  COMPILE_ARCH=$(shell uname -p | sed -e s/i.86/i386/)
endif

ifeq ($(COMPILE_PLATFORM),mingw32)
  ifeq ($(COMPILE_ARCH),i386)
    COMPILE_ARCH=x86
  endif
endif

#############################################################################
#
# If you require a different configuration from the defaults below, create a
# new file named "Makefile.local" in the same directory as this file and define
# your parameters there. This allows you to change configuration without
# causing problems with keeping up to date with the repository.
#
#############################################################################
-include Makefile.local

ifndef PLATFORM
PLATFORM=$(COMPILE_PLATFORM)
endif
export PLATFORM

ifeq ($(COMPILE_ARCH),powerpc)
  COMPILE_ARCH=ppc
endif
ifeq ($(COMPILE_ARCH),powerpc64)
  COMPILE_ARCH=ppc64
endif

ifndef ARCH
ARCH=$(COMPILE_ARCH)
endif
export ARCH

ifneq ($(PLATFORM),$(COMPILE_PLATFORM))
  CROSS_COMPILING=1
else
  CROSS_COMPILING=0

  ifneq ($(ARCH),$(COMPILE_ARCH))
    CROSS_COMPILING=1
  endif
endif
export CROSS_COMPILING

ifndef V
V=
endif
ifndef BUILD
BUILD=build
endif

ifeq ($(PLATFORM),mingw32)
	B=${BUILD}/mingw-${ARCH}

ifndef QTDIR
	QTDIR = C:/Qt4
endif
ifndef QT_LIBS
	QT_LIBS =-L${QTDIR}/lib -lQtCore4 -lQtGui4 -lQtOpenGL4 -lQtNetwork4
endif

	CC=mingw32-gcc
	CXX=mingw32-g++
	WINDRES=windres
	DEL=rm -f
	CP=cmd /c copy
	MKDIR=mkdir -p

ifndef UIC
	UIC=${QTDIR}/bin/uic.exe
endif
ifndef MOC
	MOC=${QTDIR}/bin/moc.exe
endif

	LINK=${QT_LIBS} -mwindows -lopengl32 -lglu32 -lwsock32

	BINEXT=.${ARCH}.exe
else
	B=${BUILD}/linux-${ARCH}

ifndef QTDIR
	QTDIR = /usr/share/qt4
endif
ifndef QT_LIBS
	QT_LIBS = -L/usr/${LIB} -lQtCore -lQtGui -lQtOpenGL -lQtNetwork
endif

	CC=gcc
	CXX=g++
	DEL=rm -f
	CP=cp
	MKDIR=mkdir -p

ifndef UIC
	UIC=${QTDIR}/bin/uic
endif
ifndef MOC
	MOC=${QTDIR}/bin/moc
endif

	ifeq ($(COMPILE_ARCH),x86_64)
		LIB=lib32
	else
		LIB=lib
	endif

	ifeq ($(ARCH),axp)
		ARCH=alpha
	else
	ifeq ($(ARCH),x86_64)
		LIB=lib64
	else
	ifeq ($(ARCH),ppc64)
		LIB=lib64
	else
	ifeq ($(ARCH),s390x)
		LIB=lib64
	endif
	endif
	endif
	endif

	LINK=${QT_LIBS} -lGLU -lGL -lSM -lICE  -lX11 -lXext -lXmu -lXt -lXi

	ifeq ($(ARCH),i386)
		# linux32 make ...
		BASE_FLAGS += -m32
	else
	ifeq ($(ARCH),ppc64)
		BASE_FLAGS += -m64
	endif
	endif

	BINEXT=.${ARCH}
endif

#CXXFLAGS=-Wall -g3
CXXFLAGS=-O1 ${BASE_FLAGS} -I${QTDIR}/include -DMM3D_EDIT -DQT3_SUPPORT -I. -I./src -I./src/libmm3d -I./src/mm3dcore -I./src/depui -I./src/qtui -I./src/implui -I./src/commands -I./src/tools -I${B}/depui -I${B}/qtui -I${B}/implui -I${B}/commands
DEFS=

BIN=${B}

LIB_OBJ= \
	${B}/libmm3d/bsptree.o \
	${B}/libmm3d/cal3dfilter.o \
	${B}/libmm3d/cmdlinemgr.o \
	${B}/libmm3d/cobfilter.o \
	${B}/libmm3d/datadest.o \
	${B}/libmm3d/datasource.o \
	${B}/libmm3d/filedatadest.o \
	${B}/libmm3d/filedatasource.o \
	${B}/libmm3d/memdatadest.o \
	${B}/libmm3d/memdatasource.o \
	${B}/libmm3d/dxffilter.o \
	${B}/libmm3d/filefactory.o \
	${B}/libmm3d/filtermgr.o \
	${B}/libmm3d/glmath.o \
	${B}/libmm3d/log.o \
	${B}/libmm3d/lwofilter.o \
	${B}/libmm3d/md2filter.o \
	${B}/libmm3d/md3filter.o \
	${B}/libmm3d/mesh.o \
	${B}/libmm3d/misc.o \
	${B}/libmm3d/mlocale.o \
	${B}/libmm3d/mm3dfilter.o \
	${B}/libmm3d/mm3dport.o \
	${B}/libmm3d/mm3dreg.o \
	${B}/libmm3d/model.o \
	${B}/libmm3d/model_anim.o \
	${B}/libmm3d/model_bool.o \
	${B}/libmm3d/model_copy.o \
	${B}/libmm3d/model_draw.o \
	${B}/libmm3d/model_group.o \
	${B}/libmm3d/model_influence.o \
	${B}/libmm3d/model_inner.o \
	${B}/libmm3d/model_insert.o \
	${B}/libmm3d/model_meta.o \
	${B}/libmm3d/model_ops.o \
	${B}/libmm3d/model_print.o \
	${B}/libmm3d/model_proj.o \
	${B}/libmm3d/model_select.o \
	${B}/libmm3d/model_texture.o \
	${B}/libmm3d/modelfilter.o \
	${B}/libmm3d/modelstatus.o \
	${B}/libmm3d/modelundo.o \
	${B}/libmm3d/modelutil.o \
	${B}/libmm3d/ms3dfilter.o \
	${B}/libmm3d/msg.o \
	${B}/libmm3d/objfilter.o \
	${B}/libmm3d/pcxtex.o \
	${B}/libmm3d/rawtex.o \
	${B}/libmm3d/texmgr.o \
	${B}/libmm3d/texscale.o \
	${B}/libmm3d/texture.o \
	${B}/libmm3d/tgatex.o \
	${B}/libmm3d/triprim.o \
	${B}/libmm3d/txtfilter.o \
	${B}/libmm3d/undo.o \
	${B}/libmm3d/undomgr.o \
	${B}/libmm3d/weld.o \

MM3D_UI= \
	${B}/qtui/alignwin.base.h \
	${B}/qtui/animconvertwin.base.h \
	${B}/qtui/animexportwin.base.h \
	${B}/qtui/animsetwin.base.h \
	${B}/qtui/animwidget.base.h \
	${B}/qtui/autoassignjointwin.base.h \
	${B}/qtui/backgroundselect.base.h \
	${B}/qtui/backgroundwin.base.h \
	${B}/qtui/boolwin.base.h \
	${B}/qtui/contextgroup.base.h \
	${B}/qtui/contextinfluences.base.h \
	${B}/qtui/contextname.base.h \
	${B}/qtui/contextposition.base.h \
	${B}/qtui/contextprojection.base.h \
	${B}/qtui/contextrotation.base.h \
	${B}/qtui/extrudewin.base.h \
	${B}/qtui/groupclean.base.h \
	${B}/qtui/groupwin.base.h \
	${B}/qtui/helpwin.base.h \
	${B}/qtui/jointwin.base.h \
	${B}/qtui/painttexturewin.base.h \
	${B}/qtui/pointwin.base.h \
	${B}/qtui/projectionwin.base.h \
	${B}/qtui/keyvaluewin.base.h \
	${B}/qtui/mapdirection.base.h \
	${B}/qtui/mergewin.base.h \
	${B}/qtui/metawin.base.h \
	${B}/qtui/modelview.base.h \
	${B}/qtui/newanim.base.h \
	${B}/qtui/cal3dprompt.base.h \
	${B}/qtui/ms3dprompt.base.h \
	${B}/qtui/objprompt.base.h \
	${B}/qtui/pluginwin.base.h \
	${B}/qtui/rgbawin.base.h \
	${B}/qtui/statusbar.base.h \
	${B}/qtui/texturecoord.base.h \
	${B}/qtui/textwin.base.h \
	${B}/qtui/texwin.base.h \
	${B}/qtui/transformwin.base.h \
	${B}/qtui/valuewin.base.h \
	${B}/qtui/viewportsettings.base.h

MM3D_MOC= \
	${B}/implui/alignwin.moc.cc \
	${B}/implui/aboutwin.moc.cc \
	${B}/implui/animconvertwin.moc.cc \
	${B}/implui/animexportwin.moc.cc \
	${B}/implui/animsetwin.moc.cc \
	${B}/implui/animwidget.moc.cc \
	${B}/implui/animwin.moc.cc \
	${B}/implui/autoassignjointwin.moc.cc \
	${B}/implui/backgroundselect.moc.cc \
	${B}/implui/backgroundwin.moc.cc \
	${B}/implui/boolpanel.moc.cc \
	${B}/implui/boolwin.moc.cc \
	${B}/implui/contextinfluences.moc.cc \
	${B}/implui/contextname.moc.cc \
	${B}/implui/contextpanel.moc.cc \
	${B}/implui/contextposition.moc.cc \
	${B}/implui/contextprojection.moc.cc \
	${B}/implui/contextrotation.moc.cc \
	${B}/tools/cubetoolwidget.moc.cc \
	${B}/tools/cylindertoolwidget.moc.cc \
	${B}/tools/ellipsetoolwidget.moc.cc \
	${B}/depui/errorobj.moc.cc \
	${B}/implui/extrudewin.moc.cc \
	${B}/implui/groupclean.moc.cc \
	${B}/implui/groupwin.moc.cc \
	${B}/implui/helpwin.moc.cc \
	${B}/implui/jointwin.moc.cc \
	${B}/implui/painttexturewin.moc.cc \
	${B}/implui/pointwin.moc.cc \
	${B}/implui/projectionwin.moc.cc \
	${B}/implui/keyvaluewin.moc.cc \
	${B}/implui/licensewin.moc.cc \
	${B}/implui/mergewin.moc.cc \
	${B}/implui/metawin.moc.cc \
	${B}/implui/mview.moc.cc \
	${B}/depui/modelviewport.moc.cc \
	${B}/implui/newanim.moc.cc \
	${B}/implui/cal3dprompt.moc.cc \
	${B}/implui/ms3dprompt.moc.cc \
	${B}/implui/objprompt.moc.cc \
	${B}/implui/pluginwin.moc.cc \
	${B}/tools/polytoolwidget.moc.cc \
	${B}/tools/projtoolwidget.moc.cc \
	${B}/implui/rgbawin.moc.cc \
	${B}/tools/scaletoolwidget.moc.cc \
	${B}/tools/selectfacetoolwidget.moc.cc \
	${B}/implui/spherifywin.moc.cc \
	${B}/implui/statusbar.moc.cc \
	${B}/depui/textureframe.moc.cc \
	${B}/implui/texturecoord.moc.cc \
	${B}/depui/texwidget.moc.cc \
	${B}/implui/texwin.moc.cc \
	${B}/implui/transformwin.moc.cc \
	${B}/implui/valuewin.moc.cc \
	${B}/implui/viewportsettings.moc.cc \
	${B}/implui/viewpanel.moc.cc \
	${B}/implui/viewwin.moc.cc \

MM3D_MOC_OBJ= \
	${B}/implui/alignwin.moc.o \
	${B}/implui/aboutwin.moc.o \
	${B}/implui/animconvertwin.moc.o \
	${B}/implui/animexportwin.moc.o \
	${B}/implui/animsetwin.moc.o \
	${B}/implui/animwidget.moc.o \
	${B}/implui/animwin.moc.o \
	${B}/implui/autoassignjointwin.moc.o \
	${B}/implui/backgroundselect.moc.o \
	${B}/implui/backgroundwin.moc.o \
	${B}/implui/boolpanel.moc.o \
	${B}/implui/boolwin.moc.o \
	${B}/implui/contextgroup.moc.o \
	${B}/implui/contextinfluences.moc.o \
	${B}/implui/contextname.moc.o \
	${B}/implui/contextpanel.moc.o \
	${B}/implui/contextposition.moc.o \
	${B}/implui/contextprojection.moc.o \
	${B}/implui/contextrotation.moc.o \
	${B}/tools/cubetoolwidget.moc.o \
	${B}/tools/cylindertoolwidget.moc.o \
	${B}/tools/ellipsetoolwidget.moc.o \
	${B}/tools/rotatetoolwidget.moc.o \
	${B}/tools/torustoolwidget.moc.o \
	${B}/tools/toolwidget.moc.o \
	${B}/depui/errorobj.moc.o \
	${B}/implui/extrudewin.moc.o \
	${B}/implui/groupclean.moc.o \
	${B}/implui/groupwin.moc.o \
	${B}/implui/helpwin.moc.o \
	${B}/implui/jointwin.moc.o \
	${B}/implui/painttexturewin.moc.o \
	${B}/implui/pointwin.moc.o \
	${B}/implui/projectionwin.moc.o \
	${B}/implui/keyvaluewin.moc.o \
	${B}/implui/licensewin.moc.o \
	${B}/implui/mapdirection.moc.o \
	${B}/implui/mergewin.moc.o \
	${B}/implui/metawin.moc.o \
	${B}/implui/mview.moc.o \
	${B}/depui/modelviewport.moc.o \
	${B}/implui/newanim.moc.o \
	${B}/implui/cal3dprompt.moc.o \
	${B}/implui/ms3dprompt.moc.o \
	${B}/implui/objprompt.moc.o \
	${B}/implui/pluginwin.moc.o \
	${B}/tools/polytoolwidget.moc.o \
	${B}/tools/projtoolwidget.moc.o \
	${B}/implui/rgbawin.moc.o \
	${B}/tools/scaletoolwidget.moc.o \
	${B}/tools/selectfacetoolwidget.moc.o \
	${B}/implui/spherifywin.moc.o \
	${B}/implui/statusbar.moc.o \
	${B}/depui/textureframe.moc.o \
	${B}/implui/texturecoord.moc.o \
	${B}/depui/texwidget.moc.o \
	${B}/implui/texwin.moc.o \
	${B}/implui/transformwin.moc.o \
	${B}/implui/valuewin.moc.o \
	${B}/implui/viewportsettings.moc.o \
	${B}/implui/viewpanel.moc.o \
	${B}/implui/viewwin.moc.o \

MM3D_OBJ= \
	${B}/src/3dm.o \
	${B}/mm3dcore/3dmprefs.o \
	${B}/implui/aboutwin.o \
 	${B}/mm3dcore/align.o \
	${B}/commands/aligncmd.o \
	${B}/implui/alignwin.o \
	${B}/mm3dcore/allocstats.o \
	${B}/implui/animconvertwin.o \
	${B}/implui/animexportwin.o \
	${B}/implui/animsetwin.o \
	${B}/implui/animwidget.o \
	${B}/implui/animwin.o \
	${B}/tools/atrfartool.o \
	${B}/tools/atrneartool.o \
	${B}/commands/backgroundcmd.o \
	${B}/implui/autoassignjointwin.o \
	${B}/implui/backgroundselect.o \
	${B}/implui/backgroundwin.o \
	${B}/implui/boolpanel.o \
	${B}/implui/boolwin.o \
	${B}/implui/contextgroup.o \
	${B}/implui/contextinfluences.o \
	${B}/implui/contextname.o \
	${B}/implui/contextpanel.o \
	${B}/implui/contextposition.o \
	${B}/implui/contextprojection.o \
	${B}/implui/contextrotation.o \
	${B}/mm3dcore/contextwidget.o \
	${B}/mm3dcore/contextpanelobserver.o \
	${B}/tools/bgmovetool.o \
	${B}/tools/bgscaletool.o \
	${B}/mm3dcore/bounding.o \
	${B}/mm3dcore/cmdline.o \
	${B}/mm3dcore/cmdmgr.o \
	${B}/mm3dcore/command.o \
	${B}/commands/capcmd.o \
	${B}/commands/copycmd.o \
	${B}/tools/cubetool.o \
	${B}/tools/cubetoolwidget.o \
	${B}/tools/cylindertool.o \
	${B}/tools/cylindertoolwidget.o \
	${B}/mm3dcore/decal.o \
	${B}/mm3dcore/decalmgr.o \
	${B}/commands/deletecmd.o \
	${B}/commands/dupcmd.o \
	${B}/commands/edgedivcmd.o \
	${B}/commands/edgeturncmd.o \
	${B}/tools/ellipsetool.o \
	${B}/tools/ellipsetoolwidget.o \
	${B}/tools/extrudetool.o \
	${B}/depui/errorobj.o \
	${B}/commands/extrudecmd.o \
	${B}/implui/extrudewin.o \
	${B}/commands/faceoutcmd.o \
	${B}/commands/flattencmd.o \
	${B}/commands/flipcmd.o \
	${B}/implui/groupclean.o \
	${B}/implui/groupwin.o \
	${B}/implui/helpwin.o \
	${B}/commands/hidecmd.o \
	${B}/commands/invertcmd.o \
	${B}/commands/invnormalcmd.o \
	${B}/commands/jointcmd.o \
	${B}/commands/pointcmd.o \
	${B}/commands/assignjointcmd.o \
	${B}/tools/jointtool.o \
	${B}/tools/pointtool.o \
	${B}/tools/projtool.o \
	${B}/implui/jointwin.o \
	${B}/implui/painttexturewin.o \
	${B}/implui/pointwin.o \
	${B}/implui/projectionwin.o \
	${B}/implui/keycfg.o \
	${B}/implui/keyvaluewin.o \
	${B}/implui/licensewin.o \
	${B}/mm3dcore/luaif.o \
	${B}/mm3dcore/luascript.o \
	${B}/commands/makefacecmd.o \
	${B}/implui/mapdirection.o \
	${B}/implui/mergewin.o \
	${B}/implui/metawin.o \
	${B}/tools/movetool.o \
	${B}/implui/msgqt.o \
	${B}/implui/mview.o \
	${B}/depui/modelviewport.o \
	${B}/commands/pastecmd.o \
	${B}/mm3dcore/pluginmgr.o \
	${B}/implui/newanim.o \
	${B}/implui/cal3dprompt.o \
	${B}/implui/ms3dprompt.o \
	${B}/implui/objprompt.o \
	${B}/implui/pluginwin.o \
	${B}/tools/polytool.o \
	${B}/tools/polytoolwidget.o \
	${B}/tools/projtoolwidget.o \
	${B}/mm3dcore/prefparse.o \
	${B}/mm3dcore/prefs.o \
	${B}/implui/qtmain.o \
	${B}/implui/qttex.o \
	${B}/tools/rectangletool.o \
	${B}/implui/rgbawin.o \
	${B}/mm3dcore/rotatepoint.o \
	${B}/commands/rotatetexcmd.o \
	${B}/tools/rotatetool.o \
	${B}/tools/scaletool.o \
	${B}/tools/scaletoolwidget.o \
	${B}/tools/selectfacetoolwidget.o \
	${B}/mm3dcore/scriptif.o \
	${B}/tools/selectbonetool.o \
	${B}/tools/selectpointtool.o \
	${B}/tools/selectprojtool.o \
	${B}/tools/selectconnectedtool.o \
	${B}/tools/selectfacetool.o \
	${B}/tools/selectgrouptool.o \
	${B}/tools/selectvertextool.o \
	${B}/tools/sheartool.o \
	${B}/commands/selectfreecmd.o \
	${B}/commands/simplifycmd.o \
	${B}/commands/snapcmd.o \
	${B}/commands/spherifycmd.o \
	${B}/implui/spherifywin.o \
	${B}/implui/statusbar.o \
	${B}/src/stdcmds.o \
	${B}/src/stdfilters.o \
	${B}/src/stdtexfilters.o \
	${B}/src/stdtools.o \
	${B}/commands/subdividecmd.o \
	${B}/mm3dcore/sysconf.o \
	${B}/depui/textureframe.o \
	${B}/implui/texturecoord.o \
	${B}/mm3dcore/texturetest.o \
	${B}/depui/texwidget.o \
	${B}/implui/texwin.o \
	${B}/implui/transformwin.o \
	${B}/implui/transimp.o \
	${B}/libmm3d/translate.o \
	${B}/mm3dcore/tool.o \
	${B}/mm3dcore/toolbox.o \
	${B}/mm3dcore/toolpoly.o \
	${B}/tools/rotatetoolwidget.o \
	${B}/tools/torustool.o \
	${B}/tools/torustoolwidget.o \
	${B}/tools/toolwidget.o \
	${B}/commands/unweldcmd.o \
	${B}/implui/valuewin.o \
	${B}/tools/vertextool.o \
	${B}/tools/dragvertextool.o \
	${B}/implui/viewportsettings.o \
	${B}/implui/viewpanel.o \
	${B}/implui/viewwin.o \
	${B}/implui/viewwin_influences.o \
	${B}/commands/weldcmd.o 

ifeq (${V},1)
echo_cmd=@:
Q=
else
echo_cmd=@echo
Q=@
endif

define DO_CC
$(echo_cmd) "CC $<"
$(Q)${CC} ${DEFS} -c $< -o $@ ${CXXFLAGS}
endef

define DO_CXX
$(echo_cmd) "CXX $<"
$(Q)${CXX} ${DEFS} -c $< -o $@ ${CXXFLAGS}
endef

define DO_UIC
$(echo_cmd) "UIC $<"
$(Q)${UIC} $< -o $@
endef

define DO_MOC
$(echo_cmd) "MOC $<"
$(Q)${MOC} $< -o $@
endef

.PHONY: all mm3d_ui mm3d_moc mm3d clean

all: config mm3d_ui mm3d_moc mm3d

makedirs:
	@if [ ! -d ${B} ];then ${MKDIR} ${B};fi
	@if [ ! -d ${B}/src ];then ${MKDIR} ${B}/src;fi
	@if [ ! -d ${B}/depui ];then ${MKDIR} ${B}/depui;fi
	@if [ ! -d ${B}/implui ];then ${MKDIR} ${B}/implui;fi
	@if [ ! -d ${B}/qtui ];then ${MKDIR} ${B}/qtui;fi
	@if [ ! -d ${B}/tools ];then ${MKDIR} ${B}/tools;fi
	@if [ ! -d ${B}/libmm3d ];then ${MKDIR} ${B}/libmm3d;fi
	@if [ ! -d ${B}/mm3dcore ];then ${MKDIR} ${B}/mm3dcore;fi
	@if [ ! -d ${B}/commands ];then ${MKDIR} ${B}/commands;fi

config: makedirs
#	${CP} config.h.mingw config.h

mm3d_ui: ${MM3D_UI}

mm3d_moc: ${MM3D_MOC}

$(BIN)/mm3d${BINEXT}: ${MM3D_MOC_OBJ} ${LIB_OBJ} ${MM3D_OBJ}
	$(echo_cmd) "LINKING $(BIN)/mm3d${BINEXT}"
ifeq ($(MINGW32),1)
	${WINDRES} src/icon.rc ${B}/icon.o
	$(Q)${CXX} ${CXXFLAGS} ${DEFS} -o $(BIN)/mm3d${BINEXT} ${MM3D_OBJ} ${MM3D_MOC_OBJ} ${LIB_OBJ} ${B}/icon.o ${LINK}
else
	$(Q)${CXX} ${CXXFLAGS} ${DEFS} -o $(BIN)/mm3d${BINEXT} ${MM3D_OBJ} ${MM3D_MOC_OBJ} ${LIB_OBJ} ${LINK}
endif

mm3d: $(BIN)/mm3d${BINEXT}

installer: mm3d
	cp -r ../dll .
	cp -r ../imageformats .
	strip $(BIN)/mm3d${BINEXT}
	makensis mm3d-win32-installer.nsi

${B}/%.o: src/%.c
	$(DO_CC)

${B}/%.o: src/%.cc
	$(DO_CXX)

${B}/src/%.o: src/%.cc
	$(DO_CXX)

${B}/qtui/%.base.h: src/qtui/%.ui
	$(DO_UIC)

${B}/implui/%.moc.cc: src/implui/%.h
	$(DO_MOC)

${B}/tools/%.moc.cc: src/tools/%.h
	$(DO_MOC)

${B}/depui/%.moc.cc: src/depui/%.h
	$(DO_MOC)

clean:
	$(Q)${DEL} ${LIB_OBJ}
	$(Q)${DEL} ${MM3D_UI}
	$(Q)${DEL} ${MM3D_MOC}
	$(Q)${DEL} ${MM3D_OBJ}
	$(Q)${DEL} ${MM3D_MOC_OBJ}
	$(Q)${DEL} src/*.base.*
	$(Q)${DEL} $(BIN)/mm3d.${ARCH}
	$(Q)${DEL} -r ${BUILD}

