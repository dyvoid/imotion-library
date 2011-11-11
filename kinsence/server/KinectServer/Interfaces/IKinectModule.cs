using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UsMedia.KinectServer.Interfaces
{
    interface IKinectModule : IClientMessageHandler
    {
        void OnRegister();
        void OnRemove();

        IKinectCore Core { get; set; }

        String Name { get; }

    }
}
