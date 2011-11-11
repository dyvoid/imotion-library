using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Research.Kinect.Nui;
using UsMedia.KinectServer.Server;
using UsMedia.KinectServer.Messages;
using UsMedia.KinectServer.Modules;
using UsMedia.KinectServer.Modules.HandTracking;
using UsMedia.KinectServer.Modules.SkeletonTracking;
using UsMedia.KinectServer.Modules.SpeechRecognition;
using UsMedia.KinectServer.Util;
using UsMedia.KinectServer.Interfaces;
using Newtonsoft.Json;
using System.Text.RegularExpressions;

namespace UsMedia.KinectServer
{
    class KinectCore : IKinectCore
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static readonly string NAME = "Core";

        private Runtime nui;
        private TcpServer server;

        private Dictionary<string, Type> availableModules;
        private Dictionary<string, IKinectModule> activeModules;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public KinectCore()
        {
            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public virtual IKinectModule RegisterModule( IKinectModule module )
        {
            if ( activeModules.ContainsKey( module.Name ) )
                return null;

            activeModules.Add( module.Name, module );

            module.Core = this;
            module.OnRegister();

            SendMessage( module.Name, "Registered", null );

            return module;
        }


        public virtual IKinectModule RemoveModule( string name )
        {
            if ( !activeModules.ContainsKey( name ) )
                return null;

            IKinectModule module = activeModules[ name ];

            activeModules.Remove( name );

            module.OnRemove();

            SendMessage( name, "Removed", null );

            return module;
        }


        public virtual IKinectModule RetrieveModule( string name )
        {
            if ( !activeModules.ContainsKey( name ) )
                return null;

            return activeModules[ name ];
        }


        public virtual void SetElevationAngle( int elevationAngle )
        {
            nui.NuiCamera.ElevationAngle = elevationAngle;
        }


        public virtual void SetTransformSmooth( bool isEnabled )
        {
            nui.SkeletonEngine.TransformSmooth = isEnabled;
        }


        public virtual void SetTransformSmoothParameters( TransformSmoothParameters smoothParameters )
        {
            nui.SkeletonEngine.SmoothParameters = smoothParameters;
        }


        public virtual void SendMessage( string target, string type, dynamic data )
        {
            if ( server.State == TcpServerState.Connected )
            {
                Message message = new Message { Type = target + "." + type, Data = data };
                server.SendMessage( message.ToJson() );
            }
        }


        public virtual void OnClientMessage( string type, dynamic data )
        {
            switch ( type )
            {
                case "RegisterModule":
                    string moduleName = data as string;

                    if ( availableModules.ContainsKey( moduleName ) )
                    {
                        IKinectModule module = (IKinectModule)Activator.CreateInstance( availableModules[ moduleName ] );
                        RegisterModule( module );
                    }
                    break;

                case "RemoveModule":
                    RemoveModule( data as String );
                    break;

                case "SetElevationAngle":
                    SetElevationAngle( Convert.ToInt32( data ) );
                    break;

                case "SetTransformSmooth":
                    SetTransformSmooth( Convert.ToBoolean( data ) );
                    break;

                case "SetTransformSmoothParameters":
                    TransformSmoothParameters smoothParams = new TransformSmoothParameters();

                    smoothParams.Correction = (float)data.Correction;
                    smoothParams.JitterRadius = (float) data.JitterRadius;
                    smoothParams.MaxDeviationRadius = (float) data.MaxDeviationRadius;
                    smoothParams.Prediction = (float) data.Prediction;
                    smoothParams.Smoothing = (float) data.Smoothing;

                    SetTransformSmoothParameters( smoothParams );
                    break;
            }
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private void init()
        {
            availableModules = new Dictionary<string, Type>();
            availableModules.Add( HandTrackingModule.NAME, typeof( HandTrackingModule ) );
            availableModules.Add( SkeletonTrackingModule.NAME, typeof( SkeletonTrackingModule ) );
            availableModules.Add( SpeechRecognitionModule.NAME, typeof( SpeechRecognitionModule ) );

            activeModules = new Dictionary<string, IKinectModule>();

            nui = Runtime.Kinects[0];

            try
            {
                nui.Initialize( RuntimeOptions.UseSkeletalTracking | RuntimeOptions.UseColor );
            }
            catch ( InvalidOperationException )
            {
                System.Windows.MessageBox.Show( "Runtime initialization failed. Please make sure Kinect device is plugged in." );
                return;
            }

            try
            {
                nui.VideoStream.Open( ImageStreamType.Video, 2, ImageResolution.Resolution640x480, ImageType.Color );
            }
            catch ( InvalidOperationException )
            {
                System.Windows.MessageBox.Show( "Failed to open stream. Please make sure to specify a supported image type and resolution." );
                return;
            }

            server = new TcpServer();
            server.DataReceived += new EventHandler<DataReceivedEventArgs>( server_DataReceived );
        }


        private void DeliverMessage( Message message )
        {
            string[] messageTypeArr = message.Type.Split( '.' );

            string target = messageTypeArr[ 0 ];
            string type = messageTypeArr[ 1 ];
            object data = message.Data;

            if ( target == NAME )
            {
                OnClientMessage( type, data );
            }
            else
            {
                IKinectModule module = RetrieveModule( messageTypeArr[ 0 ] );

                if ( module != null )
                {
                    module.OnClientMessage( messageTypeArr[ 1 ], data );
                }
            }
        }

        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public Runtime Nui { get { return nui; } }
        public TcpServer Server { get { return server; } }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        void server_DataReceived( object sender, DataReceivedEventArgs e )
        {
            DeliverMessage( JsonConvert.DeserializeObject<Message>( e.Message ) );
        }

    }

}
