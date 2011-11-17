using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UsMedia.KinectServer.Messages;

namespace UsMedia.KinectServer.Interfaces
{
    public interface IClientMessageHandler
    {
        void OnClientMessage( string type, dynamic data );
    }
}
