using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Research.Kinect.Nui;
using UsMedia.KinectServer.Messages;
using UsMedia.KinectServer.Server;
using UsMedia.KinectServer.Interfaces;
using Newtonsoft.Json;

namespace UsMedia.KinectServer.Modules
{
    public class AbstractModule : IKinectModule
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private string name;
        private IKinectCore core;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public AbstractModule( string name )
        {
            this.name = name;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public virtual void OnRegister() { }

        public virtual void OnRemove() { }

        public virtual void OnClientMessage( string type, dynamic data ) { }

        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED

        protected virtual void SendMessage( string type, dynamic data )
        {
            Core.SendMessage( name, type, data );
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public string Name { get { return this.name; } }

        public IKinectCore Core { get { return this.core; } set { this.core = value; } }

        protected Runtime Nui { get { return Core.Nui; } }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS        

    }

}
