#include <ruby.h>
#include <stdbool.h>
#define bool int
#include <StormLib.h>
#undef bool

static VALUE rb_SFileCreateArchive(VALUE self, VALUE filename, VALUE flags, VALUE max_file_count) {
  HANDLE hMpq;
  const char* szFileName = StringValueCStr(filename);
  DWORD dwFlags = NUM2ULONG(flags);
  DWORD dwMaxFileCount = NUM2ULONG(max_file_count);

  if (SFileCreateArchive(szFileName, dwFlags, dwMaxFileCount, &hMpq)) {
    return ULONG2NUM((uintptr_t)hMpq);
  } else {
    rb_raise(rb_eRuntimeError, "Failed to create archive");
  }
}

static VALUE rb_SFileOpenArchive(VALUE self, VALUE filename, VALUE priority, VALUE flags) {
  HANDLE hMpq;
  const char* szFileName = StringValueCStr(filename);
  DWORD dwPriority = NUM2ULONG(priority);
  DWORD dwFlags = NUM2ULONG(flags);

  if (SFileOpenArchive(szFileName, dwPriority, dwFlags, &hMpq)) {
    return ULONG2NUM((uintptr_t)hMpq);
  } else {
    rb_raise(rb_eRuntimeError, "Failed to open archive");
  }
}

static VALUE rb_SFileCloseArchive(VALUE self, VALUE handle) {
  HANDLE hMpq = (HANDLE)NUM2ULONG(handle);

  if (SFileCloseArchive(hMpq)) {
    return Qtrue;
  } else {
    return Qfalse;
  }
}

static VALUE rb_SFileAddFileEx(VALUE self, VALUE handle, VALUE filename, VALUE archived_name, VALUE flags) {
  HANDLE hMpq = (HANDLE)NUM2ULONG(handle);
  const char* szFileName = StringValueCStr(filename);
  const char* szArchivedName = StringValueCStr(archived_name);
  DWORD dwFlags = NUM2ULONG(flags);

  if (SFileAddFileEx(hMpq, szFileName, szArchivedName, dwFlags, MPQ_COMPRESSION_ZLIB, MPQ_COMPRESSION_NEXT_SAME)) {
    return Qtrue;
  } else {
    return Qfalse;
  }
}

static VALUE rb_SFileExtractFile(VALUE self, VALUE handle, VALUE archived_name, VALUE filename) {
  HANDLE hMpq = (HANDLE)NUM2ULONG(handle);
  const char* szArchivedName = StringValueCStr(archived_name);
  const char* szFileName = StringValueCStr(filename);

  if (SFileExtractFile(hMpq, szArchivedName, szFileName, SFILE_OPEN_FROM_MPQ)) {
    return Qtrue;
  } else {
    return Qfalse;
  }
}

static VALUE rb_SFileListFiles(VALUE self, VALUE handle) {
  HANDLE hMpq = (HANDLE)NUM2ULONG(handle);
  SFILE_FIND_DATA findFileData;
  HANDLE hFind;
  VALUE fileList = rb_ary_new();

  hFind = SFileFindFirstFile(hMpq, "*", &findFileData, NULL);
  if (hFind != NULL) {
    do {
      rb_ary_push(fileList, rb_str_new_cstr(findFileData.cFileName));
    } while (SFileFindNextFile(hFind, &findFileData));

    SFileFindClose(hFind);
  }

  return fileList;
}

void Init_stormlib() {
  VALUE mStormLib = rb_define_module("StormLib");

  rb_define_singleton_method(mStormLib, "create_archive", rb_SFileCreateArchive, 3);
  rb_define_singleton_method(mStormLib, "open_archive", rb_SFileOpenArchive, 3);
  rb_define_singleton_method(mStormLib, "close_archive", rb_SFileCloseArchive, 1);
  rb_define_singleton_method(mStormLib, "add_file", rb_SFileAddFileEx, 4);
  rb_define_singleton_method(mStormLib, "extract_file", rb_SFileExtractFile, 3);
  rb_define_singleton_method(mStormLib, "list_files", rb_SFileListFiles, 1);
}