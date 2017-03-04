using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Com.Reactlibrary.RNSimpleShare
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNSimpleShareModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNSimpleShareModule"/>.
        /// </summary>
        internal RNSimpleShareModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNSimpleShare";
            }
        }
    }
}
