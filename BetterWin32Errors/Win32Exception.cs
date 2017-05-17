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
        /// Custom message which can be utilized in logic code.
        /// </summary>
        public string CustomMessage { get; private set; }

        /// <summary>
        /// Create a new exception using the value from <see cref="GetLastWin32Error"/>. Note: make sure to set SetLastError=true on <see cref="DllImportAttribute"/>.
        /// </summary>
        public Win32Exception()
            : this(GetLastWin32Error())
        {
        }

        /// <summary>
        /// Create a new exception with given error code.
        /// </summary>
        public Win32Exception(Win32Error error)
            : base($"{error}: {GetMessage(error)}")
        {
            Error = error;
            ErrorMessage = GetMessage(error);
        }

        /// <summary>
        /// Create a new exception using the value from <see cref="GetLastWin32Error"/> and custom message. Note: make sure to set SetLastError=true on <see cref="DllImportAttribute"/>.
        /// </summary>
        public Win32Exception(string customMessage)
            : this(GetLastWin32Error())
        {
            CustomMessage = customMessage;
        }

        /// <summary>
        /// Create a new exception with given error code and custom message
        /// </summary>
        public Win32Exception(Win32Error error, string customMessage)
            : base($"{error}: {GetMessage(error)}")
        {
            Error = error;
            ErrorMessage = GetMessage(error);
            CustomMessage = customMessage;
        }

        static string GetMessage(Win32Error error)
        {
            var builtinException = new System.ComponentModel.Win32Exception((int)error);
            return builtinException.Message;
        }
    }
}
