using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Research.Kinect.Nui;

namespace UsMedia.KinectServer.Interfaces
{
    public interface IKinectCore : IClientMessageHandler
    {
        IKinectModule RegisterModule( IKinectModule module );
        IKinectModule RemoveModule( string name );
        IKinectModule RetrieveModule( string name );

        void SendMessage( string target, string type, dynamic data );

        Runtime Nui { get; }
    }
}
