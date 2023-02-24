library GetOsVersionHookDll;

uses
  Windows,
  CPUID in 'DDetours\CPUID.pas',
  DDetours in 'DDetours\DDetours.pas',
  InstDecode in 'DDetours\InstDecode.pas',
  LegacyTypes in 'DDetours\LegacyTypes.pas';

{$R *.res}

// Hooked function type

type
  TGetVersionExA = function(lpVersionInformation: POSVERSIONINFOA): BOOL; stdcall;
  TGetVersionExW = function(lpVersionInformation: POSVERSIONINFOW): BOOL; stdcall;

// Original function pointers

var
  _GetVersionExA: TGetVersionExA = nil;
  _GetVersionExW: TGetVersionExW = nil;

// Function stibs

function HookedGetVersionExA(lpVersionInformation: POSVERSIONINFOW): BOOL; stdcall;
begin
  if lpVersionInformation^.dwOSVersionInfoSize <> SizeOf(OSVERSIONINFOW) then
    Result := False

  else begin
    lpVersionInformation^.dwMajorVersion := 10;
    lpVersionInformation^.dwMinorVersion := 10;
    lpVersionInformation^.dwBuildNumber := 10;
    lpVersionInformation^.dwPlatformId := 10;
    lpVersionInformation^.szCSDVersion[0] := #0;
    lpVersionInformation^.szCSDVersion[1] := #0;

    Result := True;
  end;
end;

function HookedGetVersionExW(lpVersionInformation: POSVERSIONINFOW): BOOL; stdcall;
begin
  if lpVersionInformation^.dwOSVersionInfoSize <> SizeOf(OSVERSIONINFOW) then
    Result := False

  else begin
    lpVersionInformation^.dwMajorVersion := 10;
    lpVersionInformation^.dwMinorVersion := 10;
    lpVersionInformation^.dwBuildNumber := 10;
    lpVersionInformation^.dwPlatformId := 10;
    lpVersionInformation^.szCSDVersion[0] := #0;

    Result := True;
  end;
end;

// Hook management

procedure InstallFunctionHooks;
begin
  _GetVersionExA := InterceptCreate(@GetVersionExA, @HookedGetVersionExA, nil);
  _GetVersionExW := InterceptCreate(@GetVersionExW, @HookedGetVersionExW, nil);
end;

procedure UninstallFunctionHooks;
begin
  InterceptRemove(@_GetVersionExA);
  _GetVersionExA := nil;
  InterceptRemove(@_GetVersionExW);
  _GetVersionExW := nil;
end;

procedure HookDllMain(dwReason: DWORD);
begin
  case dwReason of
    DLL_PROCESS_ATTACH:
      InstallFunctionHooks;

    DLL_PROCESS_DETACH:
      UninstallFunctionHooks;

    DLL_THREAD_ATTACH:
      Exit;

    DLL_THREAD_DETACH:
      Exit;
  end;
end;

begin
  DllProc := @HookDllMain;
  HookDllMain(DLL_PROCESS_ATTACH);
end.

