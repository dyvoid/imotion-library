using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UsMedia.KinectServer.Modules.HandTracking
{
    class Hands
    {
        public int SkeletonTrackingID;
        public int SkeletonUserIndex;

        public HandData Left;
        public HandData Right;
    }
}
