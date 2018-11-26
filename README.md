# BetterWin32Errors

[![NuGet](https://img.shields.io/nuget/dt/BetterWin32Errors.svg)](https://www.nuget.org/packages/BetterWin32Errors/)


A better interface to the constants defined in winerror.h

### Simplified Error Handling

Instead of:

```csharp
if (!SomeWin32ApiCall(...))
{
    throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());
}
```

You can do this:

```csharp
if (!SomeWin32ApiCall(...))
{
    throw new BetterWin32Errors.Win32Exception();
}
```

### Access To Error Constants

Instead of re-defining platform constants in your code:

```csharp
const int ERROR_FILE_NOT_FOUND = 2;
const int ERROR_PATH_NOT_FOUND = 3;

if (!SomeWin32ApiCall(...))
{
    var error = Marshal.GetLastWin32Error();
    if (error == ERROR_FILE_NOT_FOUND)
    {
        // ...do something...
    }
    else if (error == ERROR_PATH_NOT_FOUND)
    {
        // ...do something else...
    }
    else
    {
      throw new System.ComponentModel.Win32Exception(error);
    }
}
```

You can do this:

```csharp
if (!SomeWin32ApiCall(...))
{
    var error = Win32Exception.GetLastWin32Error();
    if (error == Win32Error.ERROR_FILE_NOT_FOUND)
    {
        // ...do something...
    }
    else if (error == Win32Error.ERROR_PATH_NOT_FOUND)
    {
        // ...do something else...
    }
    else
    {
        throw new Win32Exception(error);
    }
}
```

### Exception Has Both ID and Message

```csharp
try
{
    // ...some code...
}
catch (BetterWin32Errors.Win32Exception ex)
	when (ex.Error == Win32Error.ERROR_FILE_NOT_FOUND) // use `Error` to get the error ID
{
	Console.WriteLine("Warning: " + ex.ErrorMessage);
    // Output: "Warning: The system cannot find the file specified"
}
```

## Installation

```powershell
Install-Package BetterWin32Errors
```

The only import you need to know is:

```csharp
using BetterWin32Errors;
```

## Limitations

There are thousands of error constants defined in [&lt;winerror.h&gt;](https://msdn.microsoft.com/en-us/library/windows/desktop/ms681381.aspx). All error constants included in this library were parsed using a [script](https://github.com/mkropat/BetterWin32Errors/blob/master/BetterWin32Errors/winerror2enum.ps1). As such, __there is no guarantee that the error constants have the correct values in all cases and for all platforms__. Feel free to [submit an issue](https://github.com/mkropat/BetterWin32Errors/issues) if you run into such a problem.
