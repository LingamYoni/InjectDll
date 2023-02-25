unit main;

interface

uses
  Vcl.Forms, Vcl.Controls, Vcl.ComCtrls, System.Classes, Vcl.StdCtrls;

type
  TfmMain = class(TForm)
    btEnumProcesses: TButton;
    lvProcesses: TListView;
    btInject: TButton;
    laProcessName: TLabel;
    edProcessName: TEdit;
    btFind: TButton;
    procedure btEnumProcessesClick(Sender: TObject);
    procedure btInjectClick(Sender: TObject);
    procedure btFindClick(Sender: TObject);
  end;

var
  fmMain: TfmMain;

implementation

uses
  TlHelp32, Windows, SysUtils, Dialogs;

{$R *.dfm}

procedure TfmMain.btEnumProcessesClick(Sender: TObject);
var
  Snapshot: THandle;
  ProcessEntry: TProcessEntry32;
  ContinueLoop: BOOL;
  Item: TListItem;
begin
  lvProcesses.Items.Clear;

  Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    ProcessEntry.dwSize := SizeOf(TProcessEntry32);

    ContinueLoop := Process32First(Snapshot, ProcessEntry);
    while ContinueLoop do begin
      Item := lvProcesses.Items.Add;

      Item.Caption := IntToStr(ProcessEntry.th32ProcessID);
      Item.SubItems.Add(ExtractFileName(ProcessEntry.szExeFile));

      ContinueLoop := Process32Next(Snapshot, ProcessEntry);
    end;

  finally
    CloseHandle(Snapshot);
  end;
end;

(*
#include "Injector.h"

/*
Function to retrieve the ID of a running process.
Input:
    targetProcName - The exe file name of the target process.
Output: The process's ID.
*/
DWORD Injector::getTargetProcessID(const char* targetProcName)
{
    // PROCESSENTRY32 is used to open and get information about a running process..
    PROCESSENTRY32 entry;
    entry.dwSize = sizeof(PROCESSENTRY32);

    // We use a th32snapprocess to iterate through all running processes.
    HANDLE hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, NULL);

    // Success check oon the snapshot tool.
    if (!hSnap) {
        throw "Snapshot tool failed to open";
    }

    // If a first process exist (there are running processes), iterate through
    // all running processes.
    DWORD ProcID = NULL;
    if (Process32First(hSnap, &entry)) {
        do
        {
            // If the current process entry is the target process, store its ID.
            if (!strcmp(entry.szExeFile, targetProcName))
            {
                ProcID = entry.th32ProcessID;
            }
        }
        while (Process32Next(hSnap, &entry) && !ProcID);        // Move on to the next running process.
    }
    else {
        // If there was no first process, notify the user.
        throw "No running processes found";
    }

    return ProcID;
}*)

procedure TfmMain.btFindClick(Sender: TObject);
var
  Found: Boolean;
  i: Integer;
  Item: TListItem;
begin
  Found := False;

  if lvProcesses.Items.Count > 0 then begin
    for i := 0 to lvProcesses.Items.Count - 1 do begin
      Item := lvProcesses.Items[i];
      if UpperCase(Item.SubItems[0]) = UpperCase(edProcessName.Text) then begin
        lvProcesses.Selected := Item;
        Item.MakeVisible(false);
        Found := True;
        Break;
      end;
    end;
  end;

  if not Found then
    ShowMessage('Process not found');
end;

procedure TfmMain.btInjectClick(Sender: TObject);
const
  {$IFDEF WIN32}
  DLLName: AnsiString = 'd:\Projects\Shared Projects\Windows\InjectDll\Dll\build\win32\GetOsVersionHookDll.dll';
  {$ELSE}
  DllName: AnsiString = 'd:\Projects\Shared Projects\Windows\InjectDll\Dll\build\win64\GetOsVersionHookDll.dll';
  {$ENDIF}

var
  ProcessId: DWORD;
  LoadLibraryA: Pointer;
  Kernel: HMODULE;
  Process: THandle;
  DllPathAddr: Pointer;
  Written: NativeUInt;
  RemoteThread: THandle;
  ThreadId: Cardinal;
begin
  if lvProcesses.Selected = nil then
    ShowMessage('Select process')

  else begin
    ProcessId := StrToInt(lvProcesses.Selected.Caption);

    Kernel := GetModuleHandle('Kernel32.dll');
    LoadLibraryA := GetProcAddress(Kernel, 'LoadLibraryA');
    if not Assigned(LoadLibraryA) then
      ShowMessage('LoadLibrary not found)')

    else begin
        Process := OpenProcess(PROCESS_ALL_ACCESS, FALSE, ProcessId);
        if Process = INVALID_HANDLE_VALUE then
          ShowMessage('Unable to open target process')

        else begin
          try
            DllPathAddr := VirtualAllocEx(Process, nil, Length(DLLName) + 1,
              MEM_COMMIT, PAGE_READWRITE);
            if DllPathAddr = nil then
              ShowMessage('Failed to allocate memory in the target process')

            else begin
              WriteProcessMemory(Process, DllPathAddr, Pointer(DLLName),
                Length(DLLName) + 1, Written);

              RemoteThread := CreateRemoteThread(Process, nil, 0,
                LoadLibraryA, DllPathAddr, 0, ThreadId);
              if (RemoteThread = 0) or (RemoteThread = INVALID_HANDLE_VALUE) then
                ShowMessage('Failed to load dll into target process')

              else begin
                WaitForSingleObject(RemoteThread, INFINITE);
                CloseHandle(RemoteThread);
              end;
            end;

          finally
            CloseHandle(Process);
          end;
        end;
    end;
  end;
end;

end.
