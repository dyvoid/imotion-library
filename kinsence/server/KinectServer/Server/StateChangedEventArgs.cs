using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UsMedia.KinectServer.Server
{
    class StateChangedEventArgs : EventArgs
    {
        public TcpServerState State { get; set; }
    }
}
