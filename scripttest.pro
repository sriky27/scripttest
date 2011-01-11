#-------------------------------------------------
#
# Project created by QtCreator 2011-01-05T23:32:52
#
#-------------------------------------------------

QT       += core script

QT       -= gui

TARGET = scripttest
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += main.cpp \
    scriptfunctions.cpp

HEADERS += \
    scriptfunctions.h

OTHER_FILES += \
    load.qs \
    logtosequence.qs \
    sequencediff.qs

DESTDIR = $$PWD
