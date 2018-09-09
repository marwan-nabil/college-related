#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/csma-module.h"
#include "ns3/internet-module.h"
#include "ns3/point-to-point-module.h"
#include "ns3/applications-module.h"
#include "ns3/ipv4-global-routing-helper.h"

// Default Network Topology
//
//       10.1.1.0
// n1 -------------- n3   n2   n4   n0
//    point-to-point  |    |    |    |
//                    ================
//                       10.1.2.0
// n2 has a udp server while n1 has a udp clientApps
//

using namespace ns3;

NS_LOG_COMPONENT_DEFINE ("SecondScriptExample");

int 
main (int argc, char *argv[])
{
    LogComponentEnable ("UdpEchoClientApplication", LOG_LEVEL_INFO);
    LogComponentEnable ("UdpEchoServerApplication", LOG_LEVEL_INFO);

//  create 2 pp-link nodes (1----3)
  NodeContainer p2pNodes;
  p2pNodes.Create (2);

//  creating 3 csma nodes
  NodeContainer csmaNodes;
  csmaNodes.Create (3);
  csmaNodes.Add (p2pNodes.Get (1));
  
//setting p2p channel
  PointToPointHelper pointToPoint;
  pointToPoint.SetDeviceAttribute ("DataRate", StringValue ("5Mbps"));
  pointToPoint.SetChannelAttribute ("Delay", StringValue ("2ms"));

//connecting p2pnodes with p2p channel
  NetDeviceContainer p2pDevices;
  p2pDevices = pointToPoint.Install (p2pNodes);

//creating csma bus
  CsmaHelper csma;
  csma.SetChannelAttribute ("DataRate", StringValue ("100Mbps"));
  csma.SetChannelAttribute ("Delay", TimeValue (NanoSeconds (6560)));

//connecting csmanodes on bus
  NetDeviceContainer csmaDevices;
  csmaDevices = csma.Install (csmaNodes);
  
//install internet protocol on both p2p node 1 and csmanodes (which include node 3)
  InternetStackHelper stack;
  stack.Install (p2pNodes.Get (0));
  stack.Install (csmaNodes);


//setting ip addresses for p2p devices
  Ipv4AddressHelper address;
  address.SetBase ("10.1.1.0", "255.255.255.0");
  Ipv4InterfaceContainer p2pInterfaces;
  p2pInterfaces = address.Assign (p2pDevices);

//setting ip addresses to csma nodes
  address.SetBase ("10.1.2.0", "255.255.255.0");
  Ipv4InterfaceContainer csmaInterfaces;
  csmaInterfaces = address.Assign (csmaDevices);

///////////////////////////////////////////////////////////////////////////////////
  //setting up the udp server/client pair
  UdpEchoServerHelper echoServer (9);

  ApplicationContainer serverApps = echoServer.Install (csmaNodes.Get (1));
  serverApps.Start (Seconds (1.0));
  serverApps.Stop (Seconds (10.0));

  UdpEchoClientHelper echoClient (csmaInterfaces.GetAddress (1), 9);
  echoClient.SetAttribute ("MaxPackets", UintegerValue (3));
  echoClient.SetAttribute ("Interval", TimeValue (Seconds (1.0)));
  echoClient.SetAttribute ("PacketSize", UintegerValue (1024));

  ApplicationContainer clientApps = echoClient.Install (p2pNodes.Get (0));
  clientApps.Start (Seconds (2.0));
  clientApps.Stop (Seconds (10.0));
///////////////////////////////////////////////////////////////////////////////////
  Ipv4GlobalRoutingHelper::PopulateRoutingTables ();
  pointToPoint.EnablePcapAll ("Network2");
  csma.EnablePcap ("Network2", csmaDevices.Get (1), true);
    //initial test
  Simulator::Run ();
    // TODO: display throughput and latency
  Simulator::Destroy ();
///////////////////////////////////////////////////////////////////////////////////
// second part of the test (changing latency and measuring throughput)
    for (int i =0;i<10;i++){
        pointToPoint.SetChannelAttribute ("Delay", StringValue (std::to_string(2+i*5)+"ms"));
        Simulator::Run ();
        // TODO: display throughput and latency
        Simulator::Destroy ();
    }  
//changing the latency in the CSMA channel
// second part of the test (changing latency and measuring throughput)
    for (int i =0;i<10;i++){
        csma.SetChannelAttribute ("Delay", TimeValue (NanoSeconds (6560 + 100*i)));
        Simulator::Run ();
        // TODO: display throughput and latency
        Simulator::Destroy ();
    }
  
  return 0;
}
