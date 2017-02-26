using System;
using System.Runtime.InteropServices;

namespace BetterWin32Errors
{
    /// <summary>
    /// Exception that represents a <see cref="Win32Error"/>.
    /// </summary>
    public class Win32Exception : Exception
    {
        /// <summary>
        /// Returns the last <see cref="Win32Error"/>. Note: make sure to set SetLastError=true on <see cref="DllImportAttribute"/>.
        /// </summary>
        /// <returns></returns>
        public static Win32Error GetLastWin32Error()
        {
            return (Win32Error)Marshal.GetLastWin32Error();
        }

        /// <summary>
        /// The <see cref="Win32Error"/> that the exception represents.
        /// </summary>
        public Win32Error Error { get; private set; }

        /// <summary>
        /// A human readable message associated with the <see cref="Win32Error"/>.
        /// </summary>
        public string ErrorMessage { get; private set; }

        /// <summary>
        /// Create a new exception using the value from <see cref="GetLastWin32Error"/>. Note: make sure to set SetLastError=true on <see cref="DllImportAttribute"/>.
        /// </summary>
        public Win32Exception()
            : this(GetLastWin32Error())
        {
        }

        /// <summary>
        /// </summary>
        public Win32Exception(Win32Error error)
            : base($"{error}: {GetMessage(error)}")
        {
            Error = error;
            ErrorMessage = GetMessage(error);
        }

        static string GetMessage(Win32Error error)
        {
            var builtinException = new System.ComponentModel.Win32Exception((int)error);
            return builtinException.Message;
        }
    }
}
